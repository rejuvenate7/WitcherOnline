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
#include <ws2tcpip.h>
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
static std::atomic<bool> g_run{ false };

std::string username = "Player";

static std::atomic<bool> g_shutdown{ false };
static HANDLE g_initThread = NULL;

asio::io_context io;

asio::ip::udp::resolver resolver(io);
asio::ip::udp::socket theSocket(io);

asio::ip::udp::endpoint serverEndpoint;

static std::atomic<bool> g_usernameTaken{ false };


fs::path getExecutablePath() {
	char buffer[MAX_PATH];
	GetModuleFileNameA(NULL, buffer, MAX_PATH);
	return fs::path(buffer).parent_path().parent_path();
}

static inline bool ends_with(const std::string& s, const std::string& suffix) {
	return s.size() >= suffix.size() && s.compare(s.size() - suffix.size(), suffix.size(), suffix) == 0;
}

std::vector<std::string> ParseValues(const std::string& input) {
	static const std::unordered_set<std::string> kStartMarkers = {
		"chatstart","steelstart","silverstart","armorstart","glovesstart",
		"pantsstart","bootsstart","headstart","hairstart","steelscabstart",
		"silverscabstart","crossbowstart","maskstart", "namestart"
	};

	auto toEndToken = [](const std::string& startToken) {
		return startToken.substr(0, startToken.size() - 5) + "end";
		};

	std::istringstream iss(input);
	std::string word;
	std::vector<std::string> result;

	if (!(iss >> word)) return result;

	bool inBlock = false;
	std::string blockAccum;
	std::string endToken;

	while (iss >> word) {
		if (!inBlock) {
			if (kStartMarkers.count(word)) {
				inBlock = true;
				endToken = toEndToken(word);
				blockAccum.clear();
				continue;
			}
			result.push_back(word);
		}
		else {
			if (word == endToken) {
				result.push_back(blockAccum);
				inBlock = false;
				blockAccum.clear();
				endToken.clear();
			}
			else {
				if (!blockAccum.empty()) blockAccum += ' ';
				blockAccum += word;
			}
		}
	}

	if (inBlock && !blockAccum.empty()) {
		result.push_back(blockAccum);
	}

	return result;
}

struct ExecJob { std::string code, tag; int timeoutMs; };
static std::mutex g_qMu;
static std::vector<ExecJob> g_jobs;

void PostExec(const std::string& code, const std::string& tag = "", int to = 300) {
	if (!g_run.load())
		return;

	std::lock_guard<std::mutex> lk(g_qMu);
	g_jobs.push_back({ code, tag, to });
}

void disconnectClient(std::string id)
{
	PostExec("mpghosts_disconnect(\"" + id + "\")", "", 150);
}

static inline void skip_ws(const char*& p) { while (*p == ' ' || *p == '\t' || *p == '\r') ++p; }
static bool expect(const char*& p, char ch) { skip_ws(p); if (*p != ch) return false; ++p; return true; }
static bool parse_string(const char*& p, std::string& out) {
	skip_ws(p); if (*p != '"') return false; ++p;
	const char* s = p; while (*p && *p != '"') ++p; if (*p != '"') return false;
	out.assign(s, p - s); ++p; return true;
}

std::mutex mu_;
std::unordered_map<std::string, std::vector<std::string>> world_;

void parse_world_line(const std::string& line) {
	const char* p = line.c_str();
	if (line.size() < 7) return;
	p += 6; skip_ws(p);
	if (!expect(p, '[')) return;

	std::unordered_map<std::string, std::vector<std::string>> nw;

	for (;;) {
		skip_ws(p);
		if (*p == ']') { ++p; break; }
		if (*p != '{') break; ++p;

		std::string id;
		std::vector<std::string> fields;

		for (;;) {
			skip_ws(p);
			if (*p == '}') { ++p; break; }

			std::string key; if (!parse_string(p, key)) return;
			if (!expect(p, ':')) return;

			if (key == "id") {
				std::string v; if (!parse_string(p, v)) return; id = v;
			}
			else if (key == "d") {
				if (!expect(p, '[')) return;
				for (;;) {
					skip_ws(p);
					if (*p == ']') { ++p; break; }
					std::string v; if (!parse_string(p, v)) return;
					fields.push_back(v);
					skip_ws(p);
					if (*p == ',') { ++p; continue; }
				}
			}
			else {
				while (*p && *p != ',' && *p != '}') ++p;
			}
			skip_ws(p);
			if (*p == ',') { ++p; continue; }
		}
		if (!id.empty()) nw[id] = std::move(fields);

		skip_ws(p);
		if (*p == ',') { ++p; continue; }
		if (*p == ']') { ++p; break; }
	}

	{
		std::lock_guard<std::mutex> lk(mu_);
		world_.swap(nw);
	}
}

std::unordered_map<std::string, std::vector<std::string>> snapshot() {
	std::lock_guard<std::mutex> lk(mu_);
	return world_;
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

static std::string BuildUpdatePacket(const std::string& id, const std::vector<std::string>& fields)
{
	std::string packet = "UPDATE\t" + id;

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

void pushPlayer(std::vector<std::string> p)
{
	std::string code = "mpghosts_updatePlayerData(";
	code += "\"";
	code += p[0];
	code += "\", ";

	for (int i = 0; i < p.size(); i++)
	{
		std::string value = p[i];

		if (value.find(' ') != std::string::npos) {
			value = "'" + value + "'";
		}

		code += value;

		if (i == p.size() - 1)
			code += ")";
		else
			code += ", ";
	}

	std::string out;
	g_client.ExecNoWaitLatest("pos:" + p[0], code);
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
			return;
		}

		return;
	}
	else if (parts[0] == "KICK")
	{
		g_run.store(false);
		CloseOnlineSession();
	}
	else if (parts[0] == "PLAYER")
	{
		if (parts.size() < 2)
			return;

		std::string id = parts[1];
		std::vector<std::string> fields(parts.begin() + 2, parts.end());

		{
			std::lock_guard<std::mutex> lk(mu_);
			world_[id] = std::move(fields);
		}

		pushPlayer(world_[id]);
	}
	else if (parts[0] == "REMOVE")
	{
		if (parts.size() < 2)
			return;

		std::string id = parts[1];

		{
			std::lock_guard<std::mutex> lk(mu_);
			world_.erase(id);
		}

		disconnectClient(id);
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

			if (g_client.IsConnected()) {

				std::string out;

				auto tStart = clock::now();

				bool ok = g_client.ExecTagged("mpghosts_getData(\"" + username + "\", \"" + username + "\")", "mpghosts_cli", out, 500);
				auto tEnd = clock::now();

				auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(tEnd - tStart).count();

				if (ok)
				{
					std::vector<std::string> fields = ParseValues(out);
					std::string packet = BuildUpdatePacket(username, fields);

					try {
						theSocket.send_to(asio::buffer(packet), serverEndpoint);
					}
					catch (const std::exception& e) {
						//std::cout << "Send error: " << e.what() << "\n";
					}
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
		}
		catch (const std::exception& e) {
			//std::cout << "Receive error: " << e.what() << "\n";
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

	std::string ip = xml.child("ServerIP").text().as_string();
	std::string port = xml.child("Port").text().as_string();

	if (ip.empty())
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

	serverEndpoint = *resolver.resolve(asio::ip::udp::v4(), ip, port).begin();

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