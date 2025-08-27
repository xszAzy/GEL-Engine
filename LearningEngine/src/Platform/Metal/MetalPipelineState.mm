#import "MetalPipelineState.h"
#import "GEL/Log.h"
#import "MetalContext.h"

namespace GEL {
	id<MTLRenderPipelineState> MetalPipelineState::CreateBasicPipeline(id<MTLDevice> device)
	{
		MTLVertexDescriptor* vertexDescriptor=CreateBasicVertexDescriptor();
		MTLRenderPipelineDescriptor* pipelineDescriptor=[[MTLRenderPipelineDescriptor alloc] init];
		pipelineDescriptor.label=@"Basic Pipeline";
		pipelineDescriptor.vertexDescriptor=vertexDescriptor;
		
		pipelineDescriptor.vertexFunction=[device newDefaultLibrary]?[[device newDefaultLibrary] newFunctionWithName:@"basic_vertex_function"] : nil;
		pipelineDescriptor.fragmentFunction=[device newDefaultLibrary]?[[device newDefaultLibrary] newFunctionWithName:@"basic_fragment_function"] : nil;
		if(!pipelineDescriptor.vertexFunction || !pipelineDescriptor.fragmentFunction){
			GEL_CORE_WARN("Using default Metal shaders since custom shaders are not available");
			return CreateDefaultShaderPipeline(device);
		}
		
		pipelineDescriptor.colorAttachments[0].pixelFormat=MetalContext::GetDrawablePixelFormat();
		pipelineDescriptor.colorAttachments[0].pixelFormat=MTLPixelFormatA8Unorm;
		pipelineDescriptor.colorAttachments[0].blendingEnabled=YES;
		pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor=MTLBlendFactorSourceAlpha;
		pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor=MTLBlendFactorSourceAlpha;
		
		return CreatePipelineWithDescriptor(device, pipelineDescriptor);
		
	}
	
	id<MTLRenderPipelineState> MetalPipelineState::CreatePipelineWithDescriptor(id<MTLDevice> device, MTLRenderPipelineDescriptor *descriptor){
		
		NSError* error =nil;
		id<MTLRenderPipelineState> pipelineState=[device newRenderPipelineStateWithDescriptor:descriptor error:&error];
		
		if(error){
			GEL_CORE_ERROR("Failed to create pipeline state:{0}",[[error localizedDescription] UTF8String]);
			return nil;
		}
		
		return pipelineState;
	}
	
	MTLVertexDescriptor* MetalPipelineState::CreateBasicVertexDescriptor(){
		MTLVertexDescriptor *vertexDescriptor=[MTLVertexDescriptor vertexDescriptor];
		
		vertexDescriptor.attributes[0].format=MTLVertexFormatFloat3;
		vertexDescriptor.attributes[0].offset=0;
		vertexDescriptor.attributes[0].bufferIndex=0;
		
		vertexDescriptor.attributes[1].format=MTLVertexFormatFloat4;
		vertexDescriptor.attributes[1].offset=sizeof(float)*3;
		vertexDescriptor.attributes[1].bufferIndex=0;
		
		vertexDescriptor.attributes[2].format=MTLVertexFormatFloat2;
		vertexDescriptor.attributes[2].offset=sizeof(float)*7;
		vertexDescriptor.attributes[2].bufferIndex=0;
		
		vertexDescriptor.layouts[0].stride=sizeof(float)*9;
		vertexDescriptor.layouts[0].stepRate=1;
		vertexDescriptor.layouts[0].stepFunction=MTLVertexStepFunctionPerVertex;
		
		return vertexDescriptor;
	}
	
	id<MTLRenderPipelineState> MetalPipelineState::CreateDefaultShaderPipeline(id<MTLDevice> device){
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
				return nil;
			}
			
			MTLRenderPipelineDescriptor* pipelineDescriptor=[[MTLRenderPipelineDescriptor alloc] init];
			
			pipelineDescriptor.vertexFunction=[library newFunctionWithName:@"basic_vertex_function"];
			pipelineDescriptor.fragmentFunction=[library newFunctionWithName:@"basic_fragment_function"];
			pipelineDescriptor.vertexDescriptor=CreateBasicVertexDescriptor();
			pipelineDescriptor.colorAttachments[0].pixelFormat=MetalContext::GetDrawablePixelFormat();
			
			return CreatePipelineWithDescriptor(device, pipelineDescriptor);
		}
	}
