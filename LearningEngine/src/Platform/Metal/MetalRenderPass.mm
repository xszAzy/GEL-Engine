#include "MetalRenderPass.h"
namespace GEL{

	MTLRenderPassDescriptor* MetalRenderPass::CreateDefaultRenderPassDescriptor(){
		MTLRenderPassDescriptor* renderPass=[MTLRenderPassDescriptor renderPassDescriptor];
		
		renderPass.colorAttachments[0].loadAction=MTLLoadActionClear;
		renderPass.colorAttachments[0].storeAction=MTLStoreActionStore;
		renderPass.colorAttachments[0].clearColor=MTLClearColorMake(0.2,0.3,0.1,1.0);
		
		return renderPass;
	}
	
	void MetalRenderPass::SetClearColor(MTLRenderPassDescriptor *renderPass, const glm::vec4 &color){
		if(renderPass){
			renderPass.colorAttachments[0].clearColor=MTLClearColorMake(color.r, color.g, color.b, color.a);
		}
	}
}
