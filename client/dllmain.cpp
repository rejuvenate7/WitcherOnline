#include "pch.h"
#include "script.h"
#include <iostream>
#include "DebugExecClient.h"
#include <windows.h>
#include <thread>
#include <atomic>
#include <string>
#include <sstream>
#include <vector>
#include <regex>
#include <filesystem>
#include "pugixml\pugixml.hpp"
#include <unordered_set>
#define ASIO_STANDALONE
#include <asio.hpp>
namespace fs = std::filesystem;
using namespace w3mp;

static DebugExecClient g_client;
static std::thread g_poll;
static std::thread g_game;

std::string username = "Player";

static HANDLE g_initThread = NULL;

asio::io_context io;
asio::ip::udp::resolver resolver(io);
asio::ip::udp::socket theSocket(io);
asio::ip::udp::endpoint serverEndpoint;

static std::atomic<bool> g_usernameTaken{ false };
static std::atomic<bool> g_banned{ false };
static std::atomic<bool> g_notWhitelisted{ false };
static std::atomic<bool> g_kicked{ false };
static std::atomic<bool> g_shutdown{ false };
static std::atomic<bool> g_run{ false };

struct ExecJob {
	std::string code, tag;
	int timeoutMs;
};

static std::mutex g_qMu;
static std::vector<ExecJob> g_jobs;

fs::path getExecutablePath() {
	char buffer[MAX_PATH];
	GetModuleFileNameA(NULL, buffer, MAX_PATH);
	return fs::path(buffer).parent_path().parent_path();
}

struct ParsedHalves
{
	std::vector<std::string> first;
	std::vector<std::string> second;
};

static ParsedHalves ParseValuesSplitHalf(const std::string& input)
{
	static const std::string kStartMarker = "_s";
	static const std::string kEndMarker = "_e";
	static const std::string kHalfMarker = "half";

	std::istringstream iss(input);
	std::string word;

	ParsedHalves out;
	std::vector<std::string>* current = &out.first;

	if (!(iss >> word))
		return out;

	bool inBlock = false;
	std::string blockAccum;

	while (iss >> word)
	{
		if (!inBlock)
		{
			if (word == kStartMarker)
			{
				inBlock = true;
				blockAccum.clear();
				continue;
			}

			if (word == kHalfMarker)
			{
				current = &out.second;
				continue;
			}

			if (word == kEndMarker)
			{
				current->push_back(word);
				continue;
			}

			current->push_back(word);
		}
		else
		{
			if (word == kEndMarker)
			{
				current->push_back(blockAccum);
				inBlock = false;
				blockAccum.clear();
			}
			else
			{
				if (!blockAccum.empty())
					blockAccum += ' ';
				blockAccum += word;
			}
		}
	}

	if (inBlock && !blockAccum.empty())
	{
		current->push_back(blockAccum);
	}

	return out;
}

void PostExec(const std::string& code, const std::string& tag = "", int to = 300) {
	if (!g_run.load())
		return;

	std::lock_guard<std::mutex> lk(g_qMu);
	g_jobs.push_back({ code, tag, to });
}

static std::string EscapeField(const std::string& s)
{
	std::string out;
	out.reserve(s.size());

	for (char c : s)
	{
		if (c == '\\') out += "\\\\";
		else if (c == '\t') out += "\\t";
		else if (c == '\n') out += "\\n";
		else if (c == '\r') out += "\\r";
		else out += c;
	}

	return out;
}

static std::string BuildPacket(const std::string& opcode, const std::string& id, const std::vector<std::string>& fields)
{
	std::string packet = opcode + "\t" + id;

	for (const auto& f : fields)
	{
		packet += "\t";
		packet += EscapeField(f);
	}

	return packet;
}

static std::vector<std::string> SplitTabs(const std::string& s)
{
	std::vector<std::string> parts;
	std::string cur;
	bool esc = false;

	for (char c : s)
	{
		if (esc) {
			if (c == 't') cur += '\t';
			else if (c == 'n') cur += '\n';
			else if (c == 'r') cur += '\r';
			else if (c == '\\') cur += '\\';
			else cur += c;
			esc = false;
		}
		else if (c == '\\') {
			esc = true;
		}
		else if (c == '\t') {
			parts.push_back(cur);
			cur.clear();
		}
		else {
			cur += c;
		}
	}

	parts.push_back(cur);
	return parts;
}

static std::string EscapeExecQuoted(const std::string& s, char quote)
{
	std::string out;
	out.reserve(s.size() + 8);

	for (char c : s)
	{
		if (c == '\\')
			out += "\\\\";
		else if (c == quote)
		{
			out += '\\';
			out += c;
		}
		else if (c == '\n')
			out += "\\n";
		else if (c == '\r')
			out += "\\r";
		else if (c == '\t')
			out += "\\t";
		else
			out += c;
	}

	return out;
}

static void AppendExecField(std::string& code, const std::string& value)
{
	code += ", ";

	if (value.find_first_of(" \t\r\n") != std::string::npos)
	{
		code += "'";
		code += EscapeExecQuoted(value, '\'');
		code += "'";
	}
	else
	{
		code += value;
	}
}

void pushPlayer(const std::string& id, const std::vector<std::string>& update1A, const std::vector<std::string>& update1B,
	const std::vector<std::string>& update2A, const std::vector<std::string>& update2B)
{
	if (id.empty())
		return;

	std::vector<std::string> firstHalf;
	firstHalf.reserve(update1A.size() + update1B.size());
	firstHalf.insert(firstHalf.end(), update1A.begin(), update1A.end());
	firstHalf.insert(firstHalf.end(), update1B.begin(), update1B.end());

	std::vector<std::string> secondHalf;
	secondHalf.reserve(update2A.size() + update2B.size());
	secondHalf.insert(secondHalf.end(), update2A.begin(), update2A.end());
	secondHalf.insert(secondHalf.end(), update2B.begin(), update2B.end());

	if (firstHalf.empty() || secondHalf.empty())
		return;

	std::string code1 = "wo_update(";
	code1 += "\"";
	code1 += EscapeExecQuoted(id, '"');
	code1 += "\"";

	for (size_t i = 0; i < firstHalf.size(); ++i)
	{
		AppendExecField(code1, firstHalf[i]);
	}

	code1 += ")";

	std::string code2 = "wo_update2(";
	code2 += "\"";
	code2 += EscapeExecQuoted(id, '"');
	code2 += "\"";

	for (size_t i = 0; i < secondHalf.size(); ++i)
	{
		AppendExecField(code2, secondHalf[i]);
	}

	code2 += ")";

	g_client.ExecNoWaitLatest("wo1:" + id, code1);
	g_client.ExecNoWaitLatest("wo2:" + id, code2);

	//std::cout << "Code1: " << code1 << "\n";
	//std::cout << "Code2: " << code2 << "\n";
}

static void CloseOnlineSession()
{
	try
	{
		if (theSocket.is_open())
			theSocket.close();
	}
	catch (...)
	{
	}
}

struct RemotePlayerChunks
{
	std::vector<std::string> update1A;
	std::vector<std::string> update1B;
	std::vector<std::string> update2A;
	std::vector<std::string> update2B;

	bool has1A = false;
	bool has1B = false;
	bool has2A = false;
	bool has2B = false;
};

std::mutex remoteMu;
std::unordered_map<std::string, RemotePlayerChunks> remotePlayers;

static void HandleServerPacket(const std::string& msg)
{
	auto parts = SplitTabs(msg);
	if (parts.empty())
		return;

	if (parts[0] == "ERROR")
	{
		if (parts.size() >= 2 && parts[1] == "USERNAME_TAKEN")
		{
			g_usernameTaken.store(true);
			CloseOnlineSession();
		}
		else if (parts.size() >= 2 && parts[1] == "BANNED")
		{
			g_banned.store(true);
			CloseOnlineSession();
		}
		else if (parts.size() >= 2 && parts[1] == "NOT_WHITELISTED")
		{
			g_notWhitelisted.store(true);
			CloseOnlineSession();
		}

		return;
	}
	else if (parts[0] == "KICK")
	{
		g_kicked.store(true);
		CloseOnlineSession();
		return;
	}
	else if (
		parts[0] == "UPDATE1A" ||
		parts[0] == "UPDATE1B" ||
		parts[0] == "UPDATE2A" ||
		parts[0] == "UPDATE2B")
	{
		if (parts.size() < 2)
			return;

		std::string opcode = parts[0];
		std::string id = parts[1];
		std::vector<std::string> fields(parts.begin() + 2, parts.end());

		bool readyToPush = false;

		std::vector<std::string> u1a;
		std::vector<std::string> u1b;
		std::vector<std::string> u2a;
		std::vector<std::string> u2b;

		{
			std::lock_guard<std::mutex> lk(remoteMu);
			auto& rp = remotePlayers[id];

			if (opcode == "UPDATE1A")
			{
				rp.update1A = std::move(fields);
				rp.has1A = true;
			}
			else if (opcode == "UPDATE1B")
			{
				rp.update1B = std::move(fields);
				rp.has1B = true;
			}
			else if (opcode == "UPDATE2A")
			{
				rp.update2A = std::move(fields);
				rp.has2A = true;
			}
			else if (opcode == "UPDATE2B")
			{
				rp.update2B = std::move(fields);
				rp.has2B = true;
			}

			if (rp.has1A && rp.has1B && rp.has2A && rp.has2B)
			{
				u1a = rp.update1A;
				u1b = rp.update1B;
				u2a = rp.update2A;
				u2b = rp.update2B;

				rp.has1A = false;
				rp.has1B = false;
				rp.has2A = false;
				rp.has2B = false;

				readyToPush = true;
			}
		}

		if (readyToPush)
		{
			pushPlayer(id, u1a, u1b, u2a, u2b);
		}

		return;
	}
}

static void PollPoseThread() {
	Sleep(500);
	using clock = std::chrono::steady_clock;

	while (g_run.load()) {

		try
		{
			{
				std::vector<ExecJob> jobs;
				{ std::lock_guard<std::mutex> lk(g_qMu); jobs.swap(g_jobs); }
				for (auto& j : jobs) {
					if (!g_client.IsConnected())
						break;
					std::string out;
					g_client.ExecTagged(j.code, j.tag, out, j.timeoutMs);
				}
			}

			if (g_client.IsConnected() && g_usernameTaken.load())
			{
				PostExec("usernameTaken(\"" + username + "\")", "", 150);
				Sleep(250);
				continue;
			}
			else if (g_client.IsConnected() && g_kicked.load())
			{
				PostExec("kickedMsg()", "", 150);
				Sleep(250);
				continue;
			}
			else if (g_client.IsConnected() && g_banned.load())
			{
				PostExec("bannedMsg()", "", 150);
				Sleep(250);
				continue;
			}
			else if (g_client.IsConnected() && g_notWhitelisted.load())
			{
				PostExec("notWhitelistedMsg()", "", 150);
				Sleep(250);
				continue;
			}

			if (g_client.IsConnected()) {

				std::string out;
				bool ok = g_client.ExecTagged("wo_get(\"" + username + "\")", "wo", out, 500);

				if (ok)
				{
					ParsedHalves halves = ParseValuesSplitHalf(out);

					std::string packet1a = BuildPacket("UPDATE1A", username, halves.first);
					std::string packet1b = BuildPacket("UPDATE1B", username, halves.second);

					//std::cout << "Got data 1A (" << packet1a.size() << " bytes): " << packet1a << "\n";
					//std::cout << "Got data 1B (" << packet1b.size() << " bytes): " << packet1b << "\n";

					try {
						if (!halves.first.empty())
							theSocket.send(asio::buffer(packet1a));

						if (!halves.second.empty())
							theSocket.send(asio::buffer(packet1b));
					}
					catch (const std::exception& e) {
						std::cout << "Send error (wo_get halves): " << e.what() << "\n";
					}
				}
				else
				{
					std::cout << "Failed to get Data 1 " << out << std::endl;
				}

				std::string out2;
				bool ok2 = g_client.ExecTagged("wo_get2(\"" + username + "\")", "wo2", out2, 500);

				if (ok2)
				{
					ParsedHalves halves2 = ParseValuesSplitHalf(out2);

					std::string packet2a = BuildPacket("UPDATE2A", username, halves2.first);
					std::string packet2b = BuildPacket("UPDATE2B", username, halves2.second);

					//std::cout << "Got data 2A (" << packet2a.size() << " bytes): " << packet2a << "\n";
					//std::cout << "Got data 2B (" << packet2b.size() << " bytes): " << packet2b << "\n";

					try {
						if (!halves2.first.empty())
							theSocket.send(asio::buffer(packet2a));

						if (!halves2.second.empty())
							theSocket.send(asio::buffer(packet2b));
					}
					catch (const std::exception& e) {
						std::cout << "Send error (wo_get2 halves): " << e.what() << "\n";
					}
				}
				else
				{
					std::cout << "Failed to get Data 2 " << out2 << std::endl;
				}
			}
			else
			{
				std::cout << "Not connected to game..." << std::endl;
				Sleep(100);
			}
		}
		catch (...)
		{
			std::cout << "caught exception in main loop" << std::endl;
		}
	}
}

static void SendToGameThread()
{
	Sleep(1000);
	std::vector<char> data(8192);

	while (g_run.load())
	{
		try
		{
			asio::ip::udp::endpoint senderEndpoint;

			std::size_t len = theSocket.receive_from(
				asio::buffer(data),
				senderEndpoint
			);

			std::string msg(data.data(), len);
			HandleServerPacket(msg);
			//std::cout << "Receive packet: " << msg << "\n";
		}
		catch (const std::exception& e) {
			std::cout << "Receive error: " << e.what() << "\n";
			Sleep(500);
		}
	}
}

void initScript()
{
	fs::path baseDir = getExecutablePath();
	fs::path fullPath = baseDir / "WitcherOnline" / "config.xml";

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(fullPath.c_str());

	if (!result) {
		std::cout << "Failed to load config file: " << fullPath << std::endl;
		return;
	}

	pugi::xml_node xml = doc.child("Config");

	if (!xml)
	{
		return;
	}

	std::string user = xml.child("Username").text().as_string();

	username = std::regex_replace(user, std::regex("[^A-Za-z0-9_]"), "");

	if (username.length() > 16)
	{
		username.resize(16);
	}

	std::string ip = xml.child("ServerIP").text().as_string();
	std::string port = xml.child("Port").text().as_string();

	if (ip.empty() || username.empty() || username.length() < 2)
	{
		return;
	}

	std::cout << "Username: " << username << std::endl;
	std::cout << "IP: " << ip << std::endl;
	std::cout << "Port: " << port << std::endl;
	std::cout << fullPath << std::endl;

	if (g_shutdown.load())
		return;

	g_client.Start();

	g_run.store(true);

	theSocket.open(asio::ip::udp::v4());
	theSocket.bind(asio::ip::udp::endpoint(asio::ip::udp::v4(), 0));
	serverEndpoint = *resolver.resolve(asio::ip::udp::v4(), ip, port).begin();
	theSocket.connect(serverEndpoint);

	g_poll = std::thread(PollPoseThread);
	g_game = std::thread(SendToGameThread);
}

static DWORD WINAPI InitThreadProc(LPVOID)
{
	if (g_shutdown.load())
		return 0;

	//activateConsole();

	if (g_shutdown.load())
		return 0;

	initScript();
	return 0;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD reason, LPVOID) {
	switch (reason) {
	case DLL_PROCESS_ATTACH:
		DisableThreadLibraryCalls(hModule);
		g_initThread = CreateThread(nullptr, 0, InitThreadProc, nullptr, 0, nullptr);
		if (g_initThread) {
			CloseHandle(g_initThread);
			g_initThread = NULL;
		}
		break;
	case DLL_PROCESS_DETACH:
	{
		g_shutdown.store(true);
		g_run.store(false);
		theSocket.close();
		g_client.Stop();

		{
			std::lock_guard<std::mutex> lk(g_qMu);
			g_jobs.clear();
		}

		if (g_poll.joinable())
			g_poll.join();

		if (g_game.joinable())
			g_game.join();

		//FreeConsole();
		break;
	}
	}
	return TRUE;
}