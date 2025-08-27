#include "gelpch.h"
#include "Buffer.h"
#include "Renderer.h"
#include "Platform/OpenGL/OpenGLBuffer.h"
#include "Platform/Metal/MetalBuffer.h"


namespace GEL {
	VertexBuffer* VertexBuffer::Create(float* vertices, uint32_t size) {
		switch (Renderer::GetAPI())
		{
			case RendererAPI::API::None:		GEL_CORE_ASSERT(flase, "RendererAPI::None is currently not supported!"); return nullptr;	break;
			case RendererAPI::API::OpenGL:	return new OpenGLVertexBuffer(vertices,size);	break;
			case RendererAPI::API::Metal: return new MetalVertexBuffer(vertices,size);		break;
		}

		GEL_CORE_ASSERT(false, "Unknown RendererAPI!");
		return nullptr;
	}
	IndexBuffer* IndexBuffer::Create(uint32_t* indices, uint32_t size) {
		switch (Renderer::GetAPI())
		{
			case RendererAPI::API::None:		GEL_CORE_ASSERT(flase, "RendererAPI::None is currently not supported!"); return nullptr;	break;
			case RendererAPI::API::OpenGL:	return new OpenGLIndexBuffer(indices, size);	break;
			case RendererAPI::API::Metal: return new MetalIndexBuffer(indices,size);		break;
		}

		GEL_CORE_ASSERT(false, "Unknown RendererAPI!");
		return nullptr;
	}
} // namespace GEL
