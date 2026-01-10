#pragma once
#include <winsock2.h>
#include <ws2tcpip.h>
#include <string>
#include <unordered_map>
#include <mutex>
#include <thread>
#include <atomic>
#include <functional>
#include <vector>

#pragma comment(lib, "Ws2_32.lib")

class WorldClient {
public:
	bool start(const char* ip, uint16_t port);

	void stop();

	bool sendData(const std::vector<std::string>& fields);

	std::unordered_map<std::string, std::vector<std::string>> snapshot();

	bool removeId(const std::string& id);
	void tombstone(const std::string& id, uint64_t ttl_ms = 1000);
	bool isTombstoned(const std::string& id);

	bool isConnected() const { return connected_.load(); }
	std::function<void()> onServerDown;

	void clearLocal();
	std::string getId() const;

	int getPingMs() const { return pingMs_.load(); }
private:
	std::atomic<SOCKET> s_{ INVALID_SOCKET };
	std::thread rx_;
	std::atomic<bool> run_{ false };
	std::atomic<bool> connected_{ false };

	std::string myId_;
	std::string ip_;
	uint16_t port_ = 0;

	std::unordered_map<std::string, std::vector<std::string>> world_;
	std::unordered_map<std::string, uint64_t> dead_;
	mutable std::mutex mu_;
	std::mutex tx_mu_;

	std::atomic<int> pingMs_{ -1 };

	bool send_all(const char* data, size_t n);
	void rx_thread();
	SOCKET connect_once_nonblocking(const char* ip, uint16_t port, int timeout_ms);
	void parse_world_line(const std::string& line);
};
