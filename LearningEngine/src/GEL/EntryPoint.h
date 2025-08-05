#pragma once

#ifdef GEL_PLATFORM_WINDOWS

extern GEL::Application* GEL::CreateApplication();


int main(int argc,char** argv) 
{
	GEL::Log::Init();
	GEL_CORE_WARN("Initialized Log!");
	int a = 4;
	GEL_CORE_INFO("Hello! Var={0}",a);
	auto app = GEL::CreateApplication();
	app->Run();
	delete	app;
}

#endif
