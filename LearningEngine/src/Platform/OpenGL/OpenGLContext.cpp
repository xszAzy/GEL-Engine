#include "gelpch.h"
#include "OpenGLContext.h"

#include <GLFW/glfw3.h>
#include <glad/glad.h>


namespace GEL{
	OpenGLContext::OpenGLContext(GLFWwindow* windowHandle)
		: m_WindowHandle(windowHandle)
	{
		GEL_CORE_ASSERT(windowHandle, "Window handle is null!");
	}
	void OpenGLContext::Init()
	{
		
		
		glfwMakeContextCurrent(m_WindowHandle);
		int status = gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
		GEL_CORE_ASSERT(status, "Failed to initialize Glad!");

		GEL_CORE_INFO("OpenGL Renderer:{0}",(const char*)glGetString(GL_VENDOR));
		GEL_CORE_INFO("OpenGL Version:{0}", (const char*)glGetString(GL_VERSION));
		GEL_CORE_INFO("OpenGL Shading Language Version:{0}", (const char*)glGetString(GL_SHADING_LANGUAGE_VERSION));
	}
	void OpenGLContext::SwapBuffers()
	{
		glfwSwapBuffers(m_WindowHandle);
	}
}
