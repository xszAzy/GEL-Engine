
#include "gelpch.h"
#include<glad/glad.h>
#include "GLFW/glfw3.h"
#include "ImGuiLayer.h"
#ifdef GEL_PLATFORM_WINDOWS
#include "backends/imgui_impl_opengl3.h"
#endif
#ifdef GEL_PLATFORM_MAC
#include "backends/imgui_impl_metal.h"
#include "backends/imgui_impl_osx.h"
#endif
#include "backends/imgui_impl_glfw.h"


#include "GEL/Application.h"

//temporary


namespace GEL
{
	ImGuiLayer::ImGuiLayer()
		: Layer("ImGuiLayer")
	{
	}
	ImGuiLayer::~ImGuiLayer()
	{
	}
	void ImGuiLayer::OnAttach()
	{
		// Setup Dear ImGui context
		IMGUI_CHECKVERSION();
		ImGui::CreateContext();
		ImGuiIO& io = ImGui::GetIO(); (void)io;
		io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;       // Enable Keyboard Controls
		//io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;      // Enable Gamepad Controls
		io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;           // Enable Docking
		io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;         // Enable Multi-Viewport / Platform Windows
		//io.ConfigViewportsNoAutoMerge = true;
		//io.ConfigViewportsNoTaskBarIcon = true;

		// Setup Dear ImGui style
		ImGui::StyleColorsDark();
		//ImGui::StyleColorsLight();

		// When viewports are enabled we tweak WindowRounding/WindowBg so platform windows can look identical to regular ones.
		ImGuiStyle& style = ImGui::GetStyle();
		if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
		{
			style.WindowRounding = 0.0f;
			style.Colors[ImGuiCol_WindowBg].w = 1.0f;
		}
		Application& app = Application::Get();
		GLFWwindow* window = static_cast<GLFWwindow*>(app.GetWindow().GetNativeWindow());
		
		// Setup Platform/Renderer backends
#ifdef GEL_PLATFORM_WINDOWS
		ImGui_ImplGlfw_InitForOpenGL(window, true);
		ImGui_ImplOpenGL3_Init("#version 410");
#endif
#ifdef GEL_PLATFORM_MAC
		m_Device=MTLCreateSystemDefaultDevice();
		ImGui_ImplGlfw_InitForOther(window, true);
		ImGui_ImplMetal_Init(m_Device);
		
		CreateFontTexture();
#endif
	}
	void ImGuiLayer::OnDetach()
	{
#ifdef GEL_PLATFORM_WINDOWS
		ImGui_ImplOpenGL3_Shutdown();
		ImGui_ImplGlfw_Shutdown();
#endif
#ifdef GEL_PLATFORM_MAC
		ImGui_ImplMetal_Shutdown();
#endif
		
		ImGui::DestroyContext();
	}
	void ImGuiLayer::Begin()
	{
#ifdef GEL_PLATFORM_WINDOWS
		ImGui_ImplOpenGL3_NewFrame();
		ImGui_ImplGlfw_NewFrame();
#endif
#ifdef GEL_PLATFORM_MAC
		NSWindow* window =(NSWindow*)Application::Get().GetWindow().GetNativeWindow();
		NSView* view =[window contentView];
		ImGui_ImplOSX_NewFrame(view);
		
#endif
		ImGui::NewFrame();
	}
	void ImGuiLayer::End()
	{
		// Update and Render additional Platform Windows
		ImGuiIO& io = ImGui::GetIO();
		Application& app = Application::Get();
		io.DisplaySize = ImVec2((float)app.GetWindow().GetWidth(), (float)app.GetWindow().GetHeight());
		ImGui::Render();
#ifdef GEL_PLATFORM_WINDOW
		ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());


		if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
		{
			GLFWwindow* backup_current_context = glfwGetCurrentContext();
			ImGui::UpdatePlatformWindows();
			ImGui::RenderPlatformWindowsDefault();
			glfwMakeContextCurrent(backup_current_context);
		}
#endif
	}

	void ImGuiLayer::OnImGuiRenderer()
	{
		static bool show = true;
		ImGui::ShowDemoWindow(&show);
	}
}
