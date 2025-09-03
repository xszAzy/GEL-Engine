#include "Shader.h"

#include "Renderer.h"
#include "Platform/OpenGL/OpenGLShader.h"
#include "Platform/Metal/MetalShader.h"
namespace GEL {
	
	Shader* Shader::Create(const std::string& vertexSrc,const std::string& fragmentSrc)
	{
		switch (Renderer::GetAPI())
		{
			case RendererAPI::API::None:
				GEL_CORE_ASSERT(false, "RendererAPI::None is currently not supported!"); return nullptr;
			case RendererAPI::API::OpenGL:	return new OpenGLShader(vertexSrc,fragmentSrc);
			case RendererAPI::API::Metal:	return new MetalShader(vertexSrc,fragmentSrc);
		}
		GEL_CORE_ASSERT(false, "Unknown RendererAPI!");
		return nullptr;
	}
}
