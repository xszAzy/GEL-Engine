#import "MetalRendererAPI.h"
#import "MetalPipelineState.h"
#import "MetalRenderPass.h"
#import "GEL/Renderer/Buffer.h"
#import <Metal/Metal.h>

namespace GEL{
	void MetalRendererAPI::Init(){
		GEL_CORE_INFO("Initializing Metal Renderer API...");
		
		CreatePipelineState();
		CreateDefaultRenderPassDescriptor();
		
		m_ClearConfig.clearColor=glm::vec4(0.2f,0.3f,0.1f,1.0f);
		m_ClearConfig.clearDepth=1.0f;
		m_ClearConfig.clearStencil=0;
		m_ClearConfig.clearFlags=MetalClear::ClearFlags_All;
		
		GEL_CORE_INFO("MetalRendererAPI initialized successfully!");
	}
	
	void MetalRendererAPI::SetClearColor(const glm::vec4 &color){
		m_ClearColor=color;
		m_ClearColorSet=true;
		m_ClearConfig.clearColor=color;
	}
	
	void MetalRendererAPI::Clear(){
		Clear(MetalClear::ClearFlags_All);
	}
	
	void MetalRendererAPI::Clear(uint32_t clearFlags){
		m_ClearConfig.clearFlags=clearFlags;
		
		id<MTLCommandBuffer> commandBuffer=MetalContext::GetCurrentCommandBuffer();
		if(!commandBuffer){
			GEL_CORE_WARN("No active command buffer for clear operation!");
			return;
		}
		
		if(!m_CurrentRenderPassDescriptor){
			CreateDefaultRenderPassDescriptor();
		}
		
		MetalClear::Clear(commandBuffer,(MTLRenderPassDescriptor*)m_CurrentRenderPassDescriptor,m_ClearConfig);
	}
	
	void MetalRendererAPI::ClearColor(const glm::vec4 &&color){
		SetClearColor(color);
		Clear(MetalClear::ClearFlags_Color);
	}
	
	void MetalRendererAPI::ClearDepth(float depth){
		m_ClearConfig.clearDepth=depth;
		Clear(MetalClear::ClearFlags_Depth);
	}
	
	void MetalRendererAPI::ClearStencil(uint32_t stencil){
		m_ClearConfig.clearStencil=stencil;
		Clear(MetalClear::ClearFlags_Stencil);
	}
	
	void MetalRendererAPI::SetClearConfig(const MetalClear::ClearConfig &config){
		m_ClearConfig=config;
		if(m_ClearConfig.clearFlags&MetalClear::ClearFlags_Color){
			m_ClearColor=m_ClearConfig.clearColor;
			m_ClearColorSet=true;
		}
	}
	
	const MetalClear::ClearConfig&MetalRendererAPI::GetClearConfig() const{
		return m_ClearConfig;
	}
	
	void MetalRendererAPI::CreatePipelineState()
	{
		id<MTLDevice> device=MetalContext::GetDevice();
		m_PipelineState=MetalPipelineState::CreateBasicPipeline(device);
	}
	
	void MetalRendererAPI::CreateDefaultRenderPassDescriptor(){
		m_CurrentRenderPassDescriptor=MetalRenderPass::CreateDefaultRenderPassDescriptor();
	}
	
	void MetalRendererAPI::SetViewport(uint32_t x,uint32_t y,uint32_t width,uint32_t height){
		if(m_CurrentCommandEncoder){
			[m_CurrentCommandEncoder setViewport:(MTLViewport){
				static_cast<double>(x),
				static_cast<double>(y),
				static_cast<double>(width),
				static_cast<double>(height),
				0.0,
				1.0
			}];
		}
	}
	
	void MetalRendererAPI::DrawIndexed(const std::shared_ptr<VertexArray> &vertexArray,uint32_t indexCount)
	{
		uint32_t count =indexCount ? indexCount : vertexArray->GetIndexBuffer()->GetCount();
		
		[m_CurrentCommandEncoder setRenderPipelineState:m_PipelineState];
		
		const auto& vertexBuffers=vertexArray->GetVertexBuffers();
		for(const auto& vertexBuffer : vertexBuffers){
			id<MTLBuffer> metalBuffer=(id<MTLBuffer>)vertexBuffer->GetNativeBuffer();
			if(metalBuffer){
				[m_CurrentCommandEncoder setVertexBuffer:metalBuffer offset:0 atIndex:0];
			}
		}
		
		id<MTLBuffer> indexBuffer=(id<MTLBuffer>)vertexArray->GetIndexBuffer()->GetNativeBuffer();
		if(indexBuffer){
			[m_CurrentCommandEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
												indexCount:count
												 indexType:MTLIndexTypeUInt32
											   indexBuffer:indexBuffer
										 indexBufferOffset:0];
		}
	}
}

