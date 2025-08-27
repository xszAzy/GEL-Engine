#pragma once

#import <Metal/Metal.h>
#import "glm/glm.hpp"

namespace GEL{
	namespace MetalClear{
		
		enum ClearFlags{
			ClearFlags_None=0,
			ClearFlags_Color=1<<0,
			ClearFlags_Depth=1<<1,
			ClearFlags_Stencil=1<<2,
			ClearFlags_All=ClearFlags_Color|ClearFlags_Depth|ClearFlags_Stencil
		};
		
		struct ClearConfig {
			glm::vec4 clearColor=glm::vec4(0.2f,0.3f,0.1f,1.0f);
			float clearDepth=1.0f;
			uint32_t clearStencil=0;
			uint32_t clearFlags=ClearFlags_All;
		};
		
		bool Clear(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,const ClearConfig& config);
		bool ClearColor(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,const glm::vec4& color);
		bool ClearStencil(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,uint32_t stencil=0);
		
		MTLRenderPassDescriptor* CreateClearRenderPass(MTLRenderPassDescriptor* baseRenderPass,const ClearConfig& config);
	};
}
