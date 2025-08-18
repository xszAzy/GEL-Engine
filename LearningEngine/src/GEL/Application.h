#pragma once

#include "Core.h"

#include"Window.h"
#include "GEL/LayerStack.h"
#include "Events/Event.h"
#include"Events/ApplicationEvent.h"

#include "ImGui/ImGuiLayer.h"

#include "GEL/Renderer/Shader.h"
#include "GEL/Renderer/Buffer.h"
#include "GEL/Renderer/VertexArray.h"

#include "GEL/Renderer/OrthoGraphicCamera.h"

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

		static Application& Get();
		inline Window& GetWindow() { return *m_Window; }

	private:

		bool OnWindowClose(WindowCloseEvent& e);
		std::unique_ptr<Window> m_Window;
		ImGuiLayer* m_ImGuiLayer;
		bool m_Running = true;
		LayerStack m_LayerStack;

		std::shared_ptr<Shader> m_Shader;
		std::shared_ptr<VertexArray> m_VertexArray;

        std::shared_ptr<Shader> m_NewShader;
		std::shared_ptr<VertexArray> m_SquareVA;

		OrthographicCamera m_Camera;
	private:
		static Application *s_Instance;
	};
	//To be defined in CLIENT
	Application* CreateApplication();
}
