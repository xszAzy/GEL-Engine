#pragma once

#include "GEL/Renderer/GraphicsContext.h"

struct GLFWwindow;

namespace GEL {
	class OpenGLContext : public GraphicsContext
	{
	public:
		OpenGLContext(GLFWwindow* windowHandle);
		void Init() override;
		void SwapBuffers() override;
	private:
		GLFWwindow* m_WindowHandle;
	};

}


