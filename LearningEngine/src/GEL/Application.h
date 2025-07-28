#pragma once

#include "Core.h"

namespace GEL {

	class GEL_API Application
	{
	public:

		Application()
		{
		};
		virtual ~Application()
		{
		};
		void Run();
	};
	//To be defined in CLIENT
	Application* CreateApplication();
}