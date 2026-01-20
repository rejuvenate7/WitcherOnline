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
#include "WorldClient.h"
#include <regex>
#include <filesystem>
#include "pugixml\pugixml.hpp"
#include <unordered_set>
namespace fs = std::filesystem;
using namespace w3mp;

static WorldClient g_world;

static DebugExecClient g_client;
static std::thread g_poll;
static std::atomic<bool> g_run{ false };

std::string username = "Player";

static std::atomic<bool> g_shutdown{ false };
static HANDLE g_initThread = NULL;


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

void printWorld()
{
	auto snapshot = g_world.snapshot();

	for (const auto& kv : snapshot) {
		const std::string& id = kv.first;
		std::vector<std::string> p = kv.second;
		std::cout << id << " ";
		for (int i = 0; i < p.size(); i++)
		{
			std::cout << p[i] << " ";
		}
		std::cout << std::endl;
	}

	std::cout << "my id: " << g_world.getId() << std::endl;
}
void pushWorld()
{
	auto world = g_world.snapshot();
	for (const auto& kv : world) {
		const std::string& id = kv.first;
		if (g_world.isTombstoned(id)) continue;

		std::vector<std::string> p = kv.second;

		std::string code = "mpghosts_updatePlayerData(";
		code += "\"";
		code += id;
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
		g_client.ExecNoWaitLatest("pos:" + id, code);
	}
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
			if (g_world.isConnected() && g_client.IsConnected()) {

				std::string out;
				std::string code = "mpghosts_setUserId(\"" + g_world.getId() + "\", \"" + username + "\")";
				g_client.ExecNoWaitLatest("userid", code);

				auto tStart = clock::now();

				bool ok = g_client.ExecTagged("mpghosts_getData()", "mpghosts_cli", out, 500);
				auto tEnd = clock::now();

				auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(tEnd - tStart).count();

				if (ok)
				{
					std::vector<std::string> fields = ParseValues(out);
					g_world.sendData(fields);
				}
				pushWorld();
			}
			else
			{
				std::cout << "Not connected to server..." << std::endl;
				Sleep(100);
			}
		}
		catch (...)
		{
			std::cout << "caught exception in main loop" << std::endl;
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
	int port = xml.child("Port").text().as_int();

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

	g_world.onServerDown = []() {
		PostExec("mpghosts_destroyAll()", "", 300);
		g_world.clearLocal();
		};

	g_world.start(ip.c_str(), port);

	g_poll = std::thread(PollPoseThread);
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
		g_world.stop();
		g_client.Stop();

		{
			std::lock_guard<std::mutex> lk(g_qMu);
			g_jobs.clear();
		}

		if (g_poll.joinable())
			g_poll.join();

		//FreeConsole();
		break;
	}
	}
	return TRUE;
}