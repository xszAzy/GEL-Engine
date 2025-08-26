#pragma once

extern GEL::Application* GEL::CreateApplication();


#ifdef GEL_PLATFORM_WINDOWS
int main(int argc,char** argv)
{
	GEL::Log::Init();
	GEL_CORE_WARN("Initialized Log!");
	auto app = GEL::CreateApplication();
	app->Run();
	delete    app;
}
#else ifdef GEL_PLATFORM_MAC
int main(int argc,char** argv)
{
	GEL::Log::Init();
	GEL_CORE_WARN("Initialized Log!");
	auto app = GEL::CreateApplication();
	app->Run();
	delete    app;
}
#endif


