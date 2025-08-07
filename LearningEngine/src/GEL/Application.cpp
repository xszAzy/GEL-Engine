#include "gelpch.h"
#include "Application.h"

#include <GLFW/glfw3.h>
#include <glad/glad.h>

#include "Input.h"

namespace GEL {

#define BIND_EVENT_FN(x) std::bind(&Application::x,this,std::placeholders::_1)
	Application& GEL::Application::Get()
	{ return *s_Instance; }
	Application* Application::s_Instance=nullptr;

	Application::Application() {

		GEL_CORE_ASSERT(!s_Instance, "Application already exists!");
		s_Instance = this;
		m_Window = std::unique_ptr<Window>(Window::Create());
		m_Window->SetEventCallback(BIND_EVENT_FN(OnEvent));

		m_ImGuiLayer = new ImGuiLayer();
		PushOverlay(m_ImGuiLayer);

		glGenVertexArrays(1, &m_VertexArray);
		glBindVertexArray(m_VertexArray);
		
		glGenBuffers(1, &m_VertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, m_VertexBuffer);

		//-1 : 1
		float vertices[3 * 3] = {
			-0.5f, -0.5f, 0.0f,
			 0.5f, 0.5f, 0.0f,
			 0.0f,  0.5f, 0.0f
		};
		glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE,3*sizeof(float),nullptr);

		glGenBuffers(1, &m_IndexBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IndexBuffer);

		unsigned int indices[3] = { 0,1,2 };
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

		std::string vertexSrc = R"(
			#version 330 core
			layout(location=0) in vec3 a_Position;
			out vec3 v_Position;
			void main()
			{
				v_Position = a_Position;
				gl_Position =vec4(a_Position+0.3,1.0);
			}
		)";
		std::string fragmentSrc = R"(
			#version 330 core
			layout(location=0) out vec4 color;
			in vec3 v_Position;
			void main()
			{
				color =vec4(v_Position+0.3,1.0);
			}
		)";
		m_Shader.reset(new Shader(vertexSrc,fragmentSrc));
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
		/*WindowResizeEvent e(1280, 720);
		if (e.IsInCategory(EventCategoryApplication))
			GEL_CORE_INFO("WindowResizeEvent: {0}", e.ToString());
		if (e.IsInCategory(EventCategoryInput))
			GEL_CORE_INFO("WindowResizeEvent: {0}", e.ToString());*/
		while (m_Running) {
			glClearColor(0.1f, 0.1f, 0.1f, 0.2f);
			glClear(GL_COLOR_BUFFER_BIT);

			m_Shader->Bind();
			glBindVertexArray(m_VertexArray);
			glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_INT, nullptr);

			for (Layer* layer : m_LayerStack)
				layer->OnUpdate();
			
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