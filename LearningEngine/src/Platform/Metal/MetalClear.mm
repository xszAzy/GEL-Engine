#import "MetalClear.h"
#import "GEL/Log.h"
#import "MetalContext.h"

namespace GEL{
	namespace MetalClear{
		bool Clear(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,const ClearConfig& config){
			if(!commandBuffer){
				GEL_CORE_WARN("No command buffer provided for clear operation.");
				return false;
			}
			
			if(!renderPass){
				GEL_CORE_WARN("No render pass descriptor provided for clear operation.");
				return false;
			}
			
			if(config.clearFlags==ClearFlags_None){
				return true;
			}
			
			MTLRenderPassDescriptor* clearPass=CreateClearRenderPass(renderPass, config);
			
			if(!clearPass){
				GEL_CORE_ERROR("Failed to create clear render pass");
				return false;
			}
			
			@autoreleasepool {
				id<MTLRenderCommandEncoder> encoder=[commandBuffer renderCommandEncoderWithDescriptor:clearPass];
				
				if(!encoder){
					GEL_CORE_ERROR("Failed to create render command encoder for clear.");
					return false;
				}
				[encoder endEncoding];
			}
			return true;
		}
		
		bool ClearColor(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,const glm::vec4& color){
			ClearConfig config;
			config.clearColor=color;
			config.clearFlags=ClearFlags_Color;
			
			return Clear(commandBuffer,renderPass,config);
		}
		
		bool ClearDepth(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,float depth){
			ClearConfig config;;
			config.clearDepth=depth;
			config.clearFlags=ClearFlags_Depth;
			
			return Clear(commandBuffer,renderPass,config);
		}
		
		bool ClearStencil(id<MTLCommandBuffer> commandBuffer,MTLRenderPassDescriptor* renderPass,uint32_t stencil){
			ClearConfig config;
			config.clearStencil=stencil;
			config.clearFlags=ClearFlags_Stencil;
			
			return Clear(commandBuffer,renderPass,config);
		}
		
		MTLRenderPassDescriptor* CreateClearRenderPass(MTLRenderPassDescriptor* baseRenderPass,const ClearConfig& config){
			if(!baseRenderPass){
				return nil;
			}
			
			MTLRenderPassDescriptor* clearPass=[MTLRenderPassDescriptor renderPassDescriptor];
			
			if(config.clearFlags&ClearFlags_Color&&baseRenderPass.colorAttachments[0].texture){
				clearPass.colorAttachments[0].texture=baseRenderPass.colorAttachments[0].texture;
				clearPass.colorAttachments[0].loadAction=MTLLoadActionClear;
				clearPass.colorAttachments[0].storeAction=MTLStoreActionStore;
				clearPass.colorAttachments[0].clearColor=MTLClearColorMake(config.clearColor.r, config.clearColor.g, config.clearColor.b, config.clearColor.a);
			}
			
			if(config.clearFlags & ClearFlags_Depth && baseRenderPass.depthAttachment.texture){
				clearPass.depthAttachment.texture=baseRenderPass.depthAttachment.texture;
				clearPass.depthAttachment.loadAction=MTLLoadActionClear;
				clearPass.depthAttachment.storeAction=MTLStoreActionStore;
				clearPass.depthAttachment.clearDepth=config.clearDepth;
			}
			
			if(config.clearFlags & ClearFlags_Stencil && baseRenderPass.stencilAttachment.texture){
				clearPass.stencilAttachment.texture=baseRenderPass.stencilAttachment.texture;
				clearPass.stencilAttachment.loadAction=MTLLoadActionClear;
				clearPass.stencilAttachment.storeAction=MTLStoreActionStore;
				clearPass.stencilAttachment.clearStencil=config.clearStencil;
			}
			
			return clearPass;
		}
		
		void ApplyClearConfig(MTLRenderPassDescriptor* renderPass,const ClearConfig& config){
			if(!renderPass) return;
			
			if(renderPass.colorAttachments[0].texture){
				renderPass.colorAttachments[0].loadAction=MTLLoadActionClear;
				renderPass.colorAttachments[0].clearColor=MTLClearColorMake(config.clearColor.r, config.clearColor.g, config.clearColor.b, config.clearColor.a);
			}
			else{
				renderPass.colorAttachments[0].loadAction=MTLLoadActionLoad;
			}
			
			if(renderPass.depthAttachment.texture){
				if(config.clearFlags&ClearFlags_Depth){
					renderPass.depthAttachment.loadAction=MTLLoadActionClear;
					renderPass.depthAttachment.clearDepth=config.clearDepth;
				}
				else{
					renderPass.depthAttachment.loadAction=MTLLoadActionLoad;
				}
			}
			
			if(renderPass.stencilAttachment.texture){
				renderPass.stencilAttachment.loadAction=MTLLoadActionClear;
				renderPass.stencilAttachment.clearStencil=config.clearStencil;
			}
			else{
				renderPass.stencilAttachment.loadAction=MTLLoadActionLoad;
			}
		}
	}
}
