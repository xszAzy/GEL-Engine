#pragma once

#ifdef GEL_PLATFORM_WINDOWS

extern GEL::Application* GEL::CreateApplication();


int main(int argc,char** argv) 
{
	printf("GEL Engine\n");
	auto app = GEL::CreateApplication();
	app->Run();
	delete	app;
}

#endif
