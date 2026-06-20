#include "DebugExecClient.h"
#include <ws2tcpip.h>
#include <windows.h>
#include <iostream>
#include <sstream>
#include <algorithm>

#pragma comment(lib, "Ws2_32.lib")

namespace w3mp {

	static void DBG(const char* msg) {
		OutputDebugStringA(msg);
		std::cout << msg << std::endl;
	}

	DebugExecClient::DebugExecClient() {}

	DebugExecClient::~DebugExecClient() {
		Stop();
	}

	void DebugExecClient::Start() {
		if (running_.exchange(true)) return;

		if (!wsa_inited_) {
			WSADATA wsa{};
			if (WSAStartup(MAKEWORD(2, 2), &wsa) == 0) wsa_inited_ = true;
		}
		worker_ = std::thread(&DebugExecClient::ThreadMain, this);
	}

	void DebugExecClient::Stop() {
		if (!running_.exchange(false))
			return;

		{
			std::lock_guard<std::mutex> lk(req_mu_);
			has_req_ = false;
			req_sent_ = false;
			req_reply_.reset();
		}

		{
			std::lock_guard<std::mutex> lk(ff_mu_);
			ff_q_.clear();
			ff_latest_.clear();
		}

		req_cv_.notify_all();
		rep_cv_.notify_all();

		if (worker_.joinable())
			worker_.join();

		CloseSocket();

		if (wsa_inited_) {
			WSACleanup();
			wsa_inited_ = false;
		}
	}


	bool DebugExecClient::ExecTagged(const std::string& code,
		const std::string& prefixTag,
		std::string& out_text,
		int timeout_ms)
	{
		if (!running_.load() || !connected_.load())
			return false;

		{
			std::lock_guard<std::mutex> lk(req_mu_);
			req_code_ = code;
			req_tag_ = prefixTag;
			req_reply_.reset();
			has_req_ = true;
			req_sent_ = false;
		}
		req_cv_.notify_one();

		auto deadline = std::chrono::steady_clock::now() +
			std::chrono::milliseconds(timeout_ms);
		std::unique_lock<std::mutex> lk(req_mu_);

		while (!req_reply_.has_value()) {
			if (!running_.load() || !connected_.load()) {
				has_req_ = false;
				req_sent_ = false;
				break;
			}

			if (rep_cv_.wait_until(lk, deadline) == std::cv_status::timeout) {
				has_req_ = false;
				req_sent_ = false;
				break;
			}
		}

		if (req_reply_.has_value()) {
			out_text = *req_reply_;
			return true;
		}
		return false;
	}

	bool DebugExecClient::ExecNoWait(const std::string& code)
	{
		if (!running_.load() || !connected_.load())
			return false;

		{
			std::lock_guard<std::mutex> lk(ff_mu_);
			ff_q_.push_back(code);
		}
		req_cv_.notify_one();
		return true;
	}

	bool DebugExecClient::ExecNoWaitLatest(const std::string& key, const std::string& code)
	{
		if (!running_.load() || !connected_.load())
			return false;

		{
			std::lock_guard<std::mutex> lk(ff_mu_);
			ff_latest_[key] = code;
		}
		req_cv_.notify_one();
		return true;
	}

	void DebugExecClient::CloseSocket() {
		if (sock_ != INVALID_SOCKET) { closesocket(sock_); sock_ = INVALID_SOCKET; }
		connected_.store(false);
	}

	SOCKET DebugExecClient::Connect() {
		SOCKET s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if (s == INVALID_SOCKET) return INVALID_SOCKET;

		BOOL one = TRUE; setsockopt(s, IPPROTO_TCP, TCP_NODELAY, (const char*)&one, sizeof(one));
		int to = 50; setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (const char*)&to, sizeof(to));
		setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, (const char*)&to, sizeof(to));

		sockaddr_in a{};
		a.sin_family = AF_INET;
		a.sin_port = htons(37001);

#ifdef UNICODE
		if (InetPtonW(AF_INET, L"127.0.0.1", &a.sin_addr) != 1) {
			closesocket(s);
			return INVALID_SOCKET;
		}
#else
		if (InetPtonA(AF_INET, "127.0.0.1", &a.sin_addr) != 1) {
			closesocket(s);
			return INVALID_SOCKET;
		}
#endif

		if (connect(s, reinterpret_cast<sockaddr*>(&a), sizeof(a)) == SOCKET_ERROR) {
			closesocket(s);
			return INVALID_SOCKET;
		}
		return s;
	}

	bool DebugExecClient::SendAll(const uint8_t* p, size_t n) {
		while (n) {
			int r = send(sock_, (const char*)p, (int)n, 0);
			if (r <= 0) return false;
			p += r; n -= r;
		}
		return true;
	}

	bool DebugExecClient::SendPacket(const std::vector<uint8_t>& pkt) {
		return SendAll(pkt.data(), pkt.size());
	}

	bool DebugExecClient::SendBind() {
		auto b1 = Bind("Remote");
		auto b2 = Bind("scripts");
		std::vector<uint8_t> burst;
		burst.insert(burst.end(), b1.begin(), b1.end());
		burst.insert(burst.end(), b2.begin(), b2.end());
		return SendPacket(burst);
	}

	void DebugExecClient::Utf8Sink(const std::string& s, void* user) {
		static_cast<DebugExecClient*>(user)->OnUtf8(s);
	}

	static std::string TrimLocal(const std::string& s)
	{
		const char* ws = " \t\r\n\0";
		size_t start = s.find_first_not_of(ws);

		if (start == std::string::npos)
			return "";

		size_t end = s.find_last_not_of(ws);
		return s.substr(start, end - start + 1);
	}

	static bool TryExtractTaggedLine(
		const std::string& line,
		const std::string& tag,
		std::string& reply)
	{
		std::string s = TrimLocal(line);

		if (s.empty())
			return false;

		if (tag.empty())
		{
			reply = s;
			return true;
		}

		const std::string plainPrefix = tag + " ";
		const std::string plainColonPrefix = tag + ":";
		const std::string scriptPrefix = "[Script] " + tag + " ";
		const std::string scriptColonPrefix = "[Script] " + tag + ":";
		const std::string outPrefix = "OUT: " + tag + " ";
		const std::string outNoSpacePrefix = "OUT:" + tag + " ";
		const std::string outColonPrefix = "OUT: " + tag + ":";
		const std::string outNoSpaceColonPrefix = "OUT:" + tag + ":";

		if (s.rfind(plainPrefix, 0) == 0)
		{
			reply = s;
			return true;
		}

		if (s.rfind(plainColonPrefix, 0) == 0)
		{
			reply = s;
			return true;
		}

		if (s.rfind(scriptPrefix, 0) == 0)
		{
			reply = s.substr(9); // strip "[Script] "
			return true;
		}

		if (s.rfind(scriptColonPrefix, 0) == 0)
		{
			reply = s.substr(9); // strip "[Script] "
			return true;
		}

		if (s.rfind(outPrefix, 0) == 0)
		{
			reply = s.substr(5); // strip "OUT: "
			return true;
		}

		if (s.rfind(outNoSpacePrefix, 0) == 0)
		{
			reply = s.substr(4); // strip "OUT:"
			return true;
		}

		if (s.rfind(outColonPrefix, 0) == 0)
		{
			reply = s.substr(5); // strip "OUT: "
			return true;
		}

		if (s.rfind(outNoSpaceColonPrefix, 0) == 0)
		{
			reply = s.substr(4); // strip "OUT:"
			return true;
		}

		return false;
	}

	static bool TryExtractTaggedReply(
		const std::string& raw,
		const std::string& tag,
		std::string& reply)
	{
		std::string blob = raw;

		while (!blob.empty() && (blob.back() == '\r' || blob.back() == '\n' || blob.back() == '\0'))
			blob.pop_back();

		std::replace(blob.begin(), blob.end(), '\r', '\n');

		std::istringstream lines(blob);
		std::string line;
		std::string latestMatch;
		bool found = false;

		while (std::getline(lines, line))
		{
			std::string candidate;

			if (TryExtractTaggedLine(line, tag, candidate))
			{
				latestMatch = candidate;
				found = true;
			}
		}

		if (found)
		{
			reply = latestMatch;
			return true;
		}

		return TryExtractTaggedLine(blob, tag, reply);
	}

	void DebugExecClient::OnUtf8(const std::string& raw)
	{
		std::string matchedReply;
		bool matched = false;

		{
			std::lock_guard<std::mutex> lk(req_mu_);

			if (has_req_)
			{
				if (TryExtractTaggedReply(raw, req_tag_, matchedReply))
				{
					req_reply_ = matchedReply;
					has_req_ = false;
					req_sent_ = false;
					matched = true;
				}
			}
		}

		if (matched)
		{
			rep_cv_.notify_all();
		}
	}

	void DebugExecClient::ThreadMain() {
		std::vector<uint8_t> rx;

		auto send_exec = [&](const std::string& code) -> bool {
			auto pkt = ExecutePacket(code);
			if (!SendPacket(pkt)) {
				DBG("[W3MP] send failed, dropping\n");
				CloseSocket();
				return false;
			}
			return true;
			};

		while (running_.load()) {
			while (running_.load()) {
				sock_ = Connect();
				if (sock_ != INVALID_SOCKET) {
					DBG("[W3MP] Connected\n");
					if (SendBind()) {
						connected_.store(true);
						break;
					}
					DBG("[W3MP] Bind failed\n");
					CloseSocket();
				}
				for (int ms = 0; ms < 1000 && running_.load(); ms += 100)
					Sleep(100);
			}
			if (!running_.load())
				break;

			while (running_.load() && connected_.load()) {

				bool waiting_for_reply = false;
				bool have_tag = false;
				std::string tag_code;

				{
					std::unique_lock<std::mutex> lk(req_mu_);

					waiting_for_reply = (has_req_ && req_sent_);

					if (!waiting_for_reply) {
						if (has_req_ && !req_sent_) {
							have_tag = true;
							tag_code = req_code_;
							req_sent_ = true;
						}
						else {
							req_cv_.wait_for(lk, std::chrono::milliseconds(1));
						}
					}
				}

				if (have_tag) {
					if (!send_exec(tag_code))
						break;
				}
				else if (!waiting_for_reply) {
					std::unordered_map<std::string, std::string> latest;
					{
						std::lock_guard<std::mutex> lk(ff_mu_);
						latest.swap(ff_latest_);
					}

					for (auto& kv : latest) {
						if (!send_exec(kv.second)) {
							break;
						}
					}
					if (!connected_.load())
						break;

					std::string ff;
					{
						std::lock_guard<std::mutex> lk(ff_mu_);
						if (!ff_q_.empty()) {
							ff = std::move(ff_q_.front());
							ff_q_.pop_front();
						}
					}
					if (!ff.empty()) {
						if (!send_exec(ff))
							break;
					}
				}

				uint8_t tmp[32768];
				int n = recv(sock_, (char*)tmp, sizeof(tmp), 0);

				if (n > 0) {
					rx.insert(rx.end(), tmp, tmp + n);
					size_t used = DecodeVisitUtf8Consume(rx, &DebugExecClient::Utf8Sink, this);
					if (used > 0) rx.erase(rx.begin(), rx.begin() + used);
					if (rx.size() > (1 << 20)) rx.clear();
				}
				else if (n == 0) {
					DBG("[W3MP] server closed\n");
					CloseSocket();
					break;
				}
				else {
					int e = WSAGetLastError();
					if (e != WSAETIMEDOUT && e != WSAEWOULDBLOCK) {
						char buf[128];
						sprintf_s(buf, "[W3MP] recv failed: %d\n", e);
						DBG(buf);
						CloseSocket();
						break;
					}
				}
			}
		}

		CloseSocket();
	}

}