#include <Windows.h>
#include <lua.hpp>

extern "C"
{
	__declspec(dllexport) void Plugin_Init(lua_State* state)
	{
		printf("Hello\n");

		lua_getglobal(state, "print");
		lua_pushstring(state, "Calling the print function on LUA");
		if(lua_pcall(state, 1, 0, 0) != 0) //Calling with 1 param and 0 returns expected
		{
			printf("Error\n");
		}
	}
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
		printf("DLL MAIN\n");
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

