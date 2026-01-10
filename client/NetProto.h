#pragma once
#include <cstdint>
#include <string>
#include <vector>

namespace w3mp {

	inline constexpr uint8_t T_I16[2] = { 0x81,0x16 };
	inline constexpr uint8_t T_I32[2] = { 0x81,0x32 };
	inline constexpr uint8_t T_S8[2] = { 0xAC,0x08 };
	inline constexpr uint8_t HEAD[2] = { 0xDE,0xAD };
	inline constexpr uint8_t TAIL[2] = { 0xBE,0xEF };

	void put_be16(std::vector<uint8_t>& v, uint16_t x);
	void put_be32(std::vector<uint8_t>& v, uint32_t x);
	uint16_t rd_be16(const uint8_t* p);

	void AppendInt32(std::vector<uint8_t>& p, int32_t v);
	void AppendUtf8(std::vector<uint8_t>& p, const std::string& s);

	std::vector<uint8_t> End(const std::vector<uint8_t>& payload);
	std::vector<uint8_t> Bind(const std::string& ns);
	std::vector<uint8_t> ExecutePacket(const std::string& code);

	using Utf8Callback = void(*)(const std::string& s, void* user);

	size_t DecodeVisitUtf8Consume(const std::vector<uint8_t>& buf, Utf8Callback cb, void* user);

}
