#pragma once
#include "Gel/Renderer/RendererAPI.h"
#include "MetalContext.h"

namespace GEL{
	class MetalRendererAPI : public RendererAPI
	{
	public:
		virtual void Init();
		virtual void SetViewport(uint32_t x,uint32_t y,uint32_t width,uint32_t height);
		
		virtual void SetClearColor(const glm::vec4& color)override;
		virtual void Clear() override;
		
		virtual void DrawIndexed(const std::shared_ptr<VertexArray>& vertexArray,uint32_t indexCount=0);
	private:
		void CreateDefaultRenderPassDescriptor();
		void CreatePipelineState();
		
	private:

		id<MTLCommandBuffer> m_CurrentCommandBuffer=nil;
		id<MTLRenderCommandEncoder> m_CurrentCommandEncoder=nil;
		MTLRenderPassDescriptor* m_RenderPassDescriptor=nil;
		id<MTLRenderPipelineState> m_PipelineState=nil;
		
		bool m_FrameBegun;
	};
}
