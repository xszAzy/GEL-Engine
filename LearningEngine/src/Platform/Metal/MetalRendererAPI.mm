#import "MetalRendererAPI.h"
#import "GEL/Renderer/Buffer.h"
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

namespace GEL{
	void MetalRendererAPI::Init(){
		GEL_CORE_INFO("Initializing Metal Renderer API...");
		
		CreatePipelineState();
		CreateDefaultRenderPassDescriptor();
		
		GEL_CORE_INFO("MetalRendererAPI initialized successfully!");
	}
	
	void MetalRendererAPI::CreatePipelineState()
	{
		id<MTLDevice> device=MetalContext::GetDevice();
		
		MTLVertexDescriptor* vertexDescriptor=[MTLVertexDescriptor vertexDescriptor];
		
		vertexDescriptor.attributes[0].format=MTLVertexFormatFloat3;
		vertexDescriptor.attributes[0].offset=0;
		vertexDescriptor.attributes[0].bufferIndex=0;
		
		vertexDescriptor.layouts[0].stride=sizeof(float)*9;
		vertexDescriptor.layouts[0].stepRate=1;
		vertexDescriptor.layouts[0].stepFunction=MTLVertexStepFunctionPerVertex;
		
		MTLRenderPipelineDescriptor* pipelineDescriptor=[[MTLRenderPipelineDescriptor alloc] init];
		pipelineDescriptor.label=@"Basic Pipeline";
		pipelineDescriptor.vertexFunction=[device newDefaultLibrary]?[[device newDefaultLibrary] newFunctionWithName:@"basic_vertex_function"] : nil;
		pipelineDescriptor.fragmentFunction=[device newDefaultLibrary]?[[device newDefaultLibrary] newFunctionWithName:@"basic_fragment_function"] : nil;
		pipelineDescriptor.vertexDescriptor=vertexDescriptor;
		
		pipelineDescriptor.colorAttachments[0].pixelFormat=MTLPixelFormatA8Unorm;
		pipelineDescriptor.colorAttachments[0].blendingEnabled=YES;
		pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor=MTLBlendFactorSourceAlpha;
		pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor=MTLBlendFactorSourceAlpha;
		
		if(!pipelineDescriptor.vertexFunction || !pipelineDescriptor.fragmentFunction){
			GEL_CORE_WARN("Using default Metal shaders since custom shaders are not available");
			
			const char* shaderSource=R"(
#include <metal_stdlib>
using namespace metal;
struct VertexIn {
	float3 position [[attribute(0)]];
	float4 color [[attribute(1)]];
	float2 texCoord [[attribute(2)]];
	};
vertex VertexOut basic_vertex_function(VertexIn in [[stage_in]]
{
	VertexOut out;
	out.position=float4(in.position,1.0);
	out.color=in.color;
	out.texCoord=in.texCoord;
	return out;
}

fragment float4 basic_fragment_function(VertexOut in [[stage_in]]
{
	return in.color;
}
)";
			NSError* error =nil;
			id<MTLLibrary> library=[device newLibraryWithSource:@(shaderSource)
														options:nil
														  error:&error];
			if(error){
				GEL_CORE_ERROR("Failed to create Metal Shader library:{0}",[[error localizedDescription] UTF8String]);
				return;
			}
			
			pipelineDescriptor.vertexFunction=[library newFunctionWithName:@"basic_vertex_function"];
			pipelineDescriptor.fragmentFunction=[library newFunctionWithName:@"basic_fragment_function"];
		}
		NSError* error =nil;
		m_PipelineState=[device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
		if(error){
			GEL_CORE_ERROR("Failed to create pipeline state:{0}",[[error localizedDescription] UTF8String]);
		}
	}
	
	void MetalRendererAPI::CreateDefaultRenderPassDescriptor(){
		m_RenderPassDescriptor=[MTLRenderPassDescriptor renderPassDescriptor];
		m_RenderPassDescriptor.colorAttachments[0].loadAction=MTLLoadActionClear;
		m_RenderPassDescriptor.colorAttachments[0].storeAction=MTLStoreActionStore;
		m_RenderPassDescriptor.colorAttachments[0].clearColor=MTLClearColorMake(0.2,0.3,0.1,1.0);
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
	void MetalRendererAPI::SetClearColor(const glm::vec4 &color)
	{
		if(m_RenderPassDescriptor){
			MTLRenderPassDescriptor* renderPass=(MTLRenderPassDescriptor*)m_RenderPassDescriptor;
			
			renderPass.colorAttachments[0].clearColor=MTLClearColorMake(color.r,color.g,color.b,color.a);
		}
	}
	
	void MetalRendererAPI::Clear(){
		
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
	}
}

