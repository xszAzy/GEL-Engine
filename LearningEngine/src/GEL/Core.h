#pragma once

#ifdef GEL_PLATFORM_WINDOWS
    #ifdef GEL_BUILD_DLL
        #define GEL_API __declspec(dllexport)
    #else
        #define GEL_API __declspec(dllimport)
    #endif
#else
    #error GEL only supports Window!
#endif