#include "gelpch.h"
#include "VertexArray.h"

#include "Renderer.h"
#include "Platform/OpenGL/OpenGLVertexArray.h"

namespace GEL {
	
	VertexArray* VertexArray::Create()
	{
		switch (Renderer::GetAPI())
		{
			case RendererAPI::API::None:
				GEL_CORE_ASSERT(false, "RendererAPI::None is currently not supported!"); return nullptr;
			case RendererAPI::API::OpenGL:	return new OpenGLVertexArray();
		}
		GEL_CORE_ASSERT(false, "Unknown RendererAPI!");
		return nullptr;
	}
} // namespace GEL
