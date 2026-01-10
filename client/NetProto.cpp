#include "NetProto.h"
#include <cstring>
#include <cstdlib>

namespace w3mp {

	static void append(std::vector<uint8_t>& dst, const uint8_t* p, size_t n) {
		dst.insert(dst.end(), p, p + n);
	}

	void put_be16(std::vector<uint8_t>& v, uint16_t x) {
		v.push_back(uint8_t(x >> 8)); v.push_back(uint8_t(x));
	}
	void put_be32(std::vector<uint8_t>& v, uint32_t x) {
		v.push_back(uint8_t(x >> 24)); v.push_back(uint8_t(x >> 16));
		v.push_back(uint8_t(x >> 8));  v.push_back(uint8_t(x));
	}
	uint16_t rd_be16(const uint8_t* p) {
		return (uint16_t(p[0]) << 8) | uint16_t(p[1]);
	}

	void AppendInt32(std::vector<uint8_t>& p, int32_t v) {
		append(p, T_I32, 2); put_be32(p, (uint32_t)v);
	}
	void AppendUtf8(std::vector<uint8_t>& p, const std::string& s) {
		append(p, T_S8, 2);
		append(p, T_I16, 2);
		put_be16(p, (uint16_t)s.size());
		append(p, (const uint8_t*)s.data(), s.size());
	}

	std::vector<uint8_t> End(const std::vector<uint8_t>& payload) {
		std::vector<uint8_t> out;
		append(out, HEAD, 2);
		put_be16(out, (uint16_t)(payload.size() + 6)); // total = head+size+payload+tail
		out.insert(out.end(), payload.begin(), payload.end());
		append(out, TAIL, 2);
		return out;
	}

	std::vector<uint8_t> Bind(const std::string& ns) {
		std::vector<uint8_t> p; AppendUtf8(p, "BIND"); AppendUtf8(p, ns); return End(p);
	}

	std::vector<uint8_t> ExecutePacket(const std::string& code) {
		std::vector<uint8_t> p;
		AppendUtf8(p, "Remote");
		AppendInt32(p, 0x12345678);
		AppendInt32(p, 0x81160008);
		AppendUtf8(p, code);
		return End(p);
	}

	size_t w3mp::DecodeVisitUtf8Consume(const std::vector<uint8_t>& buf,
		Utf8Callback cb, void* user) {
		if (!cb) return 0;
		size_t i = 0, lastSafe = 0;
		while (i + 6 <= buf.size()) {
			if (buf[i] != HEAD[0] || buf[i + 1] != HEAD[1]) { ++i; continue; }
			uint16_t total = rd_be16(&buf[i + 2]);
			if (total < 6 || i + total > buf.size()) break; // incomplete packet
			size_t p = i + 4;
			size_t end = i + total - 2;
			if (buf[end] != TAIL[0] || buf[end + 1] != TAIL[1]) { i += 2; continue; }

			while (p + 2 <= end) {
				uint8_t a = buf[p], b = buf[p + 1]; p += 2;
				if (a == T_S8[0] && b == T_S8[1]) {
					if (!(p + 2 <= end && buf[p] == T_I16[0] && buf[p + 1] == T_I16[1])) break;
					p += 2;
					if (p + 2 > end) break;
					uint16_t slen = rd_be16(&buf[p]); p += 2;
					if (p + slen > end) break;
					std::string s((const char*)&buf[p], (const char*)&buf[p + slen]); p += slen;
					cb(s, user);
				}
				else if (a == T_I32[0] && b == T_I32[1]) {
					if (p + 4 > end) break; p += 4;
				}
				else if (a == T_I16[0] && b == T_I16[1]) {
					if (p + 2 > end) break; p += 2;
				}
				else {
					break;
				}
			}

			i += total;
			lastSafe = i;
		}
		return lastSafe;
	}
}
