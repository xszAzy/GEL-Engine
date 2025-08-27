#pragma once
#include "GEL/Renderer/RendererAPI.h"
#import "MetalClear.h"
#include "MetalContext.h"

namespace GEL{
	class MetalRendererAPI : public RendererAPI
	{
	public:
		virtual void Init();
		virtual void SetViewport(uint32_t x,uint32_t y,uint32_t width,uint32_t height);
		
		virtual void SetClearColor(const glm::vec4& color)override;
		virtual void Clear() override;
		virtual void Clear(uint32_t clearFlags);
		virtual void ClearColor(const glm::vec4&& color);
		virtual void ClearDepth(float depth =1.0f);
		virtual void ClearStencil(uint32_t stencil=0);
		
		virtual void DrawIndexed(const std::shared_ptr<VertexArray>& vertexArray,uint32_t indexCount=0);
		
		void SetClearConfig(const MetalClear::ClearConfig& config);
		const MetalClear::ClearConfig& GetClearConfig() const;
	private:
		void CreateDefaultRenderPassDescriptor();
		void CreatePipelineState();
		
	private:
		id<MTLRenderCommandEncoder> m_CurrentCommandEncoder=nil;
		MTLRenderPassDescriptor* m_CurrentRenderPassDescriptor=nil;
		id<MTLRenderPipelineState> m_PipelineState=nil;
		
		MetalClear::ClearConfig m_ClearConfig;
		bool m_ClearColorSet=false;
		glm::vec4 m_ClearColor=glm::vec4(0.2f,0.3f,0.1f,1.0f);
	};
}
