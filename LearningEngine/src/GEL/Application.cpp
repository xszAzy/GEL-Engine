#include "Application.h"

#include <GLFW/glfw3.h>
#include <glad/glad.h>
#include "GEL/Renderer/Renderer.h"
#include "Input.h"



namespace GEL {

#define BIND_EVENT_FN(x) std::bind(&Application::x,this,std::placeholders::_1)
	Application& GEL::Application::Get()
	{ return *s_Instance; }
	Application* Application::s_Instance=nullptr;

	Application::Application()
	{

		GEL_CORE_ASSERT(!s_Instance, "Application already exists!");
		s_Instance = this;
		m_Window = std::unique_ptr<Window>(Window::Create());
		m_Window->SetEventCallback(BIND_EVENT_FN(OnEvent));

		m_ImGuiLayer = new ImGuiLayer();
		PushOverlay(m_ImGuiLayer);
		}

	void Application::PushLayer(Layer* layer)
	{
		m_LayerStack.PushLayer(layer);
		layer->OnAttach();
	}

	void Application::PushOverlay(Layer* layer)
	{
		m_LayerStack.PushOverlay(layer);
		layer->OnAttach();
	}

	void Application::OnEvent(Event& e) {


		EventDispatcher dispatcher(e);
		dispatcher.Dispatch<WindowCloseEvent>(BIND_EVENT_FN(OnWindowClose));
		//GEL_CORE_INFO("{0}", e.ToString());

		for (auto it = m_LayerStack.end(); it != m_LayerStack.begin();)
		{
			(*--it)->OnEvent(e);
			if (e.m_Handled)
				break;
		}
	}
	void Application::Run()
	{
		while (m_Running) {
			float time = (float)glfwGetTime();//Platform::GetTime()
			Timestep timestep =time -m_LastFrameTime;
			m_LastFrameTime = time;
			
			for (Layer* layer : m_LayerStack)
				layer->OnUpdate(timestep);
			
			m_ImGuiLayer->Begin();
			for (Layer* layer : m_LayerStack) {
				layer->OnImGuiRenderer();
			}
			m_ImGuiLayer->End();

			m_Window->OnUpdate();
		}
	}
	bool Application::OnWindowClose(WindowCloseEvent& e)
	{
		m_Running = false;
		return true;
	}
}
