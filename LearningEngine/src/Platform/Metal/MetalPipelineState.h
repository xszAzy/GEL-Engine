#pragma once

#import <Metal/Metal.h>
#import "glm/glm.hpp"

namespace GEL {
	class MetalPipelineState{
	public:
		static id<MTLRenderPipelineState> CreateBasicPipeline(id<MTLDevice> device);
		static id<MTLRenderPipelineState> CreatePipelineWithDescriptor(id<MTLDevice> device,MTLRenderPipelineDescriptor* descriptor);
		static MTLVertexDescriptor* CreateBasicVertexDescriptor();
		
	private:
		static id<MTLRenderPipelineState> CreateDefaultShaderPipeline(id<MTLDevice> device);
	};
}
