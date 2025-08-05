#pragma once


#include "Core.h"
#include <spdlog/spdlog.h>
#include <spdlog/fmt/ostr.h>

namespace GEL
{
	class GEL_API Log
	{
	public:
		static void Init();
		static std::shared_ptr<spdlog::logger>& GetCoreLogger();
		static std::shared_ptr<spdlog::logger>& GetClientLogger();
	private:
		static std::shared_ptr<spdlog::logger> s_CoreLogger;
		static std::shared_ptr<spdlog::logger>s_ClientLogger;
	};
}
//Core Log Macros
#define GEL_CORE_TRACE(...)		::GEL::Log::GetCoreLogger()->trace(__VA_ARGS__)
#define GEL_CORE_INFO(...)		::GEL::Log::GetCoreLogger()->info(__VA_ARGS__)
#define GEL_CORE_WARN(...)		::GEL::Log::GetCoreLogger()->warn(__VA_ARGS__)
#define GEL_CORE_ERROR(...)		::GEL::Log::GetCoreLogger()->error(__VA_ARGS__)
#define GEL_CORE_FATAL(...)		::GEL::Log::GetCoreLogger()->fatal(__VA_ARGS__)
//Client Log Macros
#define GEL_TRACE(...)		::GEL::Log::GetClientLogger()->trace(__VA_ARGS__)
#define GEL_INFO(...)		::GEL::Log::GetClientLogger()->info(__VA_ARGS__)
#define GEL_WARN(...)		::GEL::Log::GetClientLogger()->warn(__VA_ARGS__)
#define GEL_ERROR(...)		::GEL::Log::GetClientLogger()->error(__VA_ARGS__)
#define GEL_FATAL(...)		::GEL::Log::GetClientLogger()->fatal(__VA_ARGS__)
		  