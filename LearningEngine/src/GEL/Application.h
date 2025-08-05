#pragma once

#include "Core.h"

#include"Window.h"
#include "GEL/LayerStack.h"
#include "Events/Event.h"

#include"Events/ApplicationEvent.h"

namespace GEL{
	class GEL_API Application
	{
	public:
		Application();
		virtual ~Application() { };
		void Run();

		void OnEvent(Event& e);

		void PushLayer(Layer* layer);
		void PushOverlay(Layer* layer);

		inline static Application& Get();
		inline Window& GetWindow() { return *m_Window; }
		
	private:
		
		bool OnWindowClose(WindowCloseEvent& e);
		std::unique_ptr<Window> m_Window;
		bool m_Running = true;
		LayerStack m_LayerStack;
		static Application *s_Instance;
	};
	//To be defined in CLIENT
	Application* CreateApplication();
}