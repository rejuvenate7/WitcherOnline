#include "pch.h"
#include <iostream>

void activateConsole()
{
	AllocConsole();
	SetConsoleTitleA("Multiplayer Client Console");
	FILE* pCout;
	freopen_s(&pCout, "CONOUT$", "w", stdout);
	freopen_s(&pCout, "CONOUT$", "w", stderr);
	std::cout.clear();
	std::clog.clear();
	std::cerr.clear();
}

