#pragma once

#import <Metal/Metal.h>
#import "glm/glm.hpp"

namespace GEL {
	class MetalRenderPass{
	public:
		static MTLRenderPassDescriptor* CreateDefaultRenderPassDescriptor();
		static void SetClearColor(MTLRenderPassDescriptor* renderPass,const glm::vec4& color);
	private:
		MetalRenderPass()=delete;
		~MetalRenderPass()=delete;
	};
}
