#include "gelpch.h"
#include "VertexArray.h"

#include "Renderer.h"
#include "Platform/OpenGL/OpenGLVertexArray.h"
#include "Platform/Metal/MetalVertexArray.h"
namespace GEL {
	
	VertexArray* VertexArray::Create()
	{
		switch (Renderer::GetAPI())
		{
			case RendererAPI::API::None:
				GEL_CORE_ASSERT(false, "RendererAPI::None is currently not supported!"); return nullptr;
			case RendererAPI::API::OpenGL:	return new OpenGLVertexArray();
			case RendererAPI::API::Metal:	return new MetalVertexArray();
		}
		GEL_CORE_ASSERT(false, "Unknown RendererAPI!");
		return nullptr;
	}
}
