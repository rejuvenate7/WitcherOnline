#include "WorldClient.h"
#include <iostream>
#include <cstring>
#include <cstdlib>
#include "dllmain.h"
#include <chrono>

static uint64_t now_ms()
{
	using namespace std::chrono;
	return duration_cast<milliseconds>(steady_clock::now().time_since_epoch()).count();
}

bool WorldClient::removeId(const std::string& id)
{
	std::lock_guard<std::mutex> lk(mu_);
	return world_.erase(id) > 0;
}

void WorldClient::tombstone(const std::string& id, uint64_t ttl_ms)
{
	std::lock_guard<std::mutex> lk(mu_);
	dead_[id] = now_ms() + ttl_ms;
}

bool WorldClient::isTombstoned(const std::string& id)
{
	std::lock_guard<std::mutex> lk(mu_);

	auto it = dead_.find(id);

	if (it == dead_.end())
		return false;

	if (now_ms() > it->second)
	{
		dead_.erase(it);
		return false;
	}
	return true;
}

static bool set_nodelay(SOCKET s)
{
	BOOL one = TRUE;
	return setsockopt(s, IPPROTO_TCP, TCP_NODELAY, (const char*)&one, sizeof(one)) == 0;
}

bool WorldClient::send_all(const char* data, size_t n)
{
	SOCKET s = s_.load();
	if (s == INVALID_SOCKET)
		return false;

	while (n)
	{
		int r = send(s, data, (int)n, 0);
		if (r <= 0)
			return false;

		data += r;
		n -= (size_t)r;
	}
	return true;
}

SOCKET WorldClient::connect_once_nonblocking(const char* ip, uint16_t port, int timeout_ms)
{
	SOCKET s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

	if (s == INVALID_SOCKET)
		return INVALID_SOCKET;

	u_long nb = 1;
	ioctlsocket(s, FIONBIO, &nb);

	sockaddr_in a{};
	a.sin_family = AF_INET;
	a.sin_port = htons(port);

	if (inet_pton(AF_INET, ip, &a.sin_addr) != 1) {
		closesocket(s); return INVALID_SOCKET;
	}

	int rc = connect(s, (sockaddr*)&a, sizeof(a));
	if (rc == SOCKET_ERROR) {
		int e = WSAGetLastError();
		if (e != WSAEWOULDBLOCK && e != WSAEINPROGRESS) {
			closesocket(s); return INVALID_SOCKET;
		}
		fd_set wfds;
		FD_ZERO(&wfds);
		FD_SET(s, &wfds);
		timeval tv{};
		tv.tv_sec = timeout_ms / 1000;
		tv.tv_usec = (timeout_ms % 1000) * 1000;
		rc = select(0, nullptr, &wfds, nullptr, &tv);
		if (rc <= 0)
		{
			closesocket(s); return INVALID_SOCKET;
		}

		int soerr = 0;
		int slen = sizeof(soerr);
		getsockopt(s, SOL_SOCKET, SO_ERROR, (char*)&soerr, &slen);
		if (soerr != 0)
		{
			closesocket(s);
			return INVALID_SOCKET;
		}
	}

	nb = 0; ioctlsocket(s, FIONBIO, &nb);

	set_nodelay(s);
	int to = 1000;
	setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (char*)&to, sizeof(to));
	setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, (char*)&to, sizeof(to));
	return s;
}

bool WorldClient::start(const char* ip, uint16_t port) {
	if (run_.load()) return true;

	ip_ = ip;
	port_ = port;

	run_.store(true);
	rx_ = std::thread(&WorldClient::rx_thread, this);
	return true;
}

void WorldClient::stop() {
	run_.store(false);

	{
		std::lock_guard<std::mutex> lk(tx_mu_);

		SOCKET s = s_.exchange(INVALID_SOCKET);
		if (s != INVALID_SOCKET) {
			const char* bye = "BYE\n";
			send(s, bye, (int)strlen(bye), 0);
			shutdown(s, SD_SEND);
			closesocket(s);
		}
	}

	if (rx_.joinable()) rx_.join();

	connected_.store(false);
	std::lock_guard<std::mutex> lk(mu_);
	world_.clear();
	dead_.clear();
	myId_.clear();
}

bool WorldClient::sendData(const std::vector<std::string>& fields) {
	if (!connected_.load())
		return false;

	std::string line = "DATA";
	for (const auto& f : fields) {
		line.push_back('\t');
		line += f;
	}
	line.push_back('\n');

	std::lock_guard<std::mutex> lk(tx_mu_);

	if (s_.load() == INVALID_SOCKET)
		return false;

	return send_all(line.c_str(), line.size());
}

std::unordered_map<std::string, std::vector<std::string>> WorldClient::snapshot() {
	std::lock_guard<std::mutex> lk(mu_);
	return world_;
}

static inline void skip_ws(const char*& p) { while (*p == ' ' || *p == '\t' || *p == '\r') ++p; }
static bool expect(const char*& p, char ch) { skip_ws(p); if (*p != ch) return false; ++p; return true; }
static bool parse_string(const char*& p, std::string& out) {
	skip_ws(p); if (*p != '"') return false; ++p;
	const char* s = p; while (*p && *p != '"') ++p; if (*p != '"') return false;
	out.assign(s, p - s); ++p; return true;
}

void WorldClient::parse_world_line(const std::string& line) {
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

void WorldClient::rx_thread() {
	while (run_.load())
	{
		SOCKET s = connect_once_nonblocking(ip_.c_str(), port_, 300);
		if (s == INVALID_SOCKET) {
			for (int i = 0; i < 10 && run_.load(); ++i)
				Sleep(100);
			continue;
		}

		{
			std::lock_guard<std::mutex> lk(tx_mu_);
			s_.store(s);
		}
		connected_.store(true);

		{
			std::lock_guard<std::mutex> lk(tx_mu_);
			std::string hello = "HELLO \n";
			send_all(hello.c_str(), hello.size());
		}

		std::string buf; buf.reserve(4096);
		auto pop_line = [&](std::string& b, std::string& out)->bool {
			auto pos = b.find('\n');
			if (pos == std::string::npos) return false;
			out.assign(b, 0, pos);
			b.erase(0, pos + 1);
			if (!out.empty() && out.back() == '\r') out.pop_back();
			return true;
			};

		uint64_t nextPingAt = now_ms() + 1000;
		uint64_t lastPingSentAt = 0;
		bool waitingForPong = false;

		while (run_.load())
		{
			uint64_t now = now_ms();
			if (now >= nextPingAt) {
				nextPingAt = now + 1000;

				if (!waitingForPong && s_ != INVALID_SOCKET) {
					std::lock_guard<std::mutex> lk(tx_mu_);
					const char* pingLine = "PING\n";
					if (send_all(pingLine, strlen(pingLine))) {
						lastPingSentAt = now;
						waitingForPong = true;
					}
				}
			}

			char tmp[2048];
			int n = recv(s_, tmp, sizeof(tmp), 0);
			if (n > 0)
			{
				buf.append(tmp, tmp + n);
				for (std::string line; pop_line(buf, line); )
				{
					if (line.empty())
						continue;

					if (line == "PONG") {
						if (waitingForPong && lastPingSentAt != 0) {
							uint64_t now2 = now_ms();
							int rtt = (int)(now2 - lastPingSentAt);
							pingMs_.store(rtt);
							waitingForPong = false;

							std::lock_guard<std::mutex> lk(tx_mu_);
							std::string pingReport = "PING " + std::to_string(rtt) + "\n";
							send_all(pingReport.c_str(), pingReport.size());
						}
						continue;
					}

					if (line.rfind("WELCOME ", 0) == 0)
					{
						std::string myId = line.substr(8);
						std::cout << "My client ID: " << myId << std::endl;

						{
							std::lock_guard<std::mutex> lk(mu_);
							myId_ = myId;
						}
					}

					if (line.rfind("DISCONNECT ", 0) == 0)
					{
						std::string id = line.substr(11);
						if (!id.empty()) {
							removeId(id);
							tombstone(id, 1500);
							disconnectClient(id);
						}
						continue;
					}
					if (line.rfind("WORLD ", 0) == 0)
					{
						parse_world_line(line);
					}
				}
			}
			else if (n == 0) {
				break;
			}
			else
			{
				if (WSAGetLastError() != WSAETIMEDOUT)
					break;
			}
		}

		SOCKET toClose = INVALID_SOCKET;
		{
			std::lock_guard<std::mutex> lk(tx_mu_);
			toClose = s_.exchange(INVALID_SOCKET);
		}
		if (toClose != INVALID_SOCKET) {
			closesocket(toClose);
		}

		connected_.store(false);

		clearLocal();

		if (onServerDown) {
			onServerDown();
		}

		for (int i = 0; i < 10 && run_.load(); ++i)
		{
			Sleep(100);
		}
	}
}

void WorldClient::clearLocal() {
	std::lock_guard<std::mutex> lk(mu_);
	world_.clear();
	dead_.clear();
}

std::string WorldClient::getId() const {
	std::lock_guard<std::mutex> lk(mu_);
	return myId_;
}