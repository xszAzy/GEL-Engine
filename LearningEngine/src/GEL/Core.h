#pragma once

#ifdef GEL_PLATFORM_WINDOWS
	#if GEL_DYNAMIC_LINK
		#ifdef GEL_BUILD_DLL
			#define GEL_API __declspec(dllexport)
		#else
			#define GEL_API __declspec(dllimport)
		#endif
	#else
		#define GEL_API
	#endif
#endif
#ifdef GEL_PLATFORM_MAC
	#define GEL_API
#endif

#ifdef GEL_ENABLE_ASSERTS
    #define GEL_ASSERT(x,...){if(!(x)){GEL_ERROR("Assertion Failed:{0}",__VA_ARGS__);__debugbreak();}}
    #define GEL_CORE_ASSERT(x,...){if(!(x)){GEL_ERROR("Assertion Failed:{0}",__VA_ARGS__);__debugbreak();}}
#else
    #define GEL_ASSERT(x,...)
    #define GEL_CORE_ASSERT(x,...)
#endif

#define BIT(x) (1<<x)
#define GEL_BIND_EVENT_FN(fn) std::bind(&fn, this, std::placeholders::_1)
