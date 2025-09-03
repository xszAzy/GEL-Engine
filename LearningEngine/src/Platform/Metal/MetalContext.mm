#import "MetalContext.h"
#import <Foundation/Foundation.h>

namespace GEL{
	CAMetalLayer* MetalContext::s_Layer=nil;
	id<MTLDevice> MetalContext::s_Device=nil;
	id<MTLCommandQueue> MetalContext::s_CommandQueue=nil;
	id<MTLCommandBuffer> MetalContext::s_CurrentCommandBuffer=nil;
	id<CAMetalDrawable> MetalContext::s_CurrentDrawable=nil;
	
	MTLRenderPassDescriptor* MetalContext::s_RenderPassDescriptor=nil;
	
	MTLPixelFormat MetalContext::s_PixelFormat=MTLPixelFormatA8Unorm;
	
	void MetalContext::Init(id<MTLDevice> device,CAMetalLayer* layer){
		s_Device=device;
		s_Layer=layer;
		s_CommandQueue=[s_Device newCommandQueue];
		
		if(s_Layer){
			s_Layer.device=s_Device;
			s_PixelFormat=s_Layer.pixelFormat;
		}
		else{
			s_PixelFormat=MTLPixelFormatA8Unorm;
		}
		
		CreateRenderPassDescriptor();
	}
	
	void MetalContext::Shutdown()
	{
		s_CurrentDrawable=nil;
		s_CurrentCommandBuffer=nil;
		s_RenderPassDescriptor=nil;
		s_CommandQueue=nil;
		s_Device=nil;
		s_Layer=nil;
	}
	
	id<MTLCommandBuffer> MetalContext::GetCurrentCommandBuffer(){
		if(!s_CommandQueue){
			GEL_CORE_ERROR("No Command Queue Available!");
			return nil;
		}
		
		if(!s_CurrentCommandBuffer){
			s_CurrentCommandBuffer=[s_CommandQueue commandBuffer];
			s_CurrentCommandBuffer.label=@"GEL_CurrentCommandBuffer!";
		}
		
		return s_CurrentCommandBuffer;
	}
	
	id<MTLCommandBuffer> MetalContext::CreateNewCommandBuffer(){
		if(!s_CommandQueue){
			GEL_CORE_ERROR("No Command Queue Available!");
			return nil;
		}
		
		if(s_CurrentCommandBuffer){
			[s_CurrentCommandBuffer commit];
			s_CurrentCommandBuffer=nil;
		}
		
		s_CurrentCommandBuffer=[s_CommandQueue commandBuffer];
		s_CurrentCommandBuffer.label=@"GEL_NewCommandBuffer";
		
		return s_CurrentCommandBuffer;
	}
	
	void MetalContext::CommitCurrentCommandBuffer(){
		if(s_CurrentCommandBuffer){
			[s_CurrentCommandBuffer commit];
			s_CurrentCommandBuffer=nil;
		}
	}
	
	id<CAMetalDrawable>MetalContext::GetCurrentDrawable(){
		if(!s_CurrentDrawable){
			s_CurrentDrawable=[s_Layer nextDrawable];
		}
		return s_CurrentDrawable;
	}
	
	void MetalContext::UpdateRenderPassDescriptorWithCurrentDrawable(){
		if(!s_RenderPassDescriptor)
			CreateRenderPassDescriptor();
		
		id<CAMetalDrawable> drawable=GetCurrentDrawable();
		if(drawable&&drawable.texture)
			s_RenderPassDescriptor.colorAttachments[0].texture=drawable.texture;
		else
			GEL_CORE_WARN("No Valid drawable texture for render pass!");
	}
	
	void MetalContext::CreateRenderPassDescriptor()
	{
		s_RenderPassDescriptor=[MTLRenderPassDescriptor renderPassDescriptor];
		
		id<CAMetalDrawable> drawable=GetCurrentDrawable();
		if(drawable&&drawable.texture)
			s_RenderPassDescriptor.colorAttachments[0].texture=drawable.texture;
		
		s_RenderPassDescriptor.colorAttachments[0].loadAction=MTLLoadActionClear;
		
		s_RenderPassDescriptor.colorAttachments[0].storeAction=MTLStoreActionStore;
		
		s_RenderPassDescriptor.colorAttachments[0].clearColor=MTLClearColorMake(0.3, 0.1, 0.2, 1.0);
	}
	
	void MetalContext::BeginFrame(){
		s_CurrentDrawable=[s_Layer nextDrawable];
		GetCurrentCommandBuffer();
		
		UpdateRenderPassDescriptorWithCurrentDrawable();
	}
	
	void MetalContext::EndFrame(){
		if(s_CurrentCommandBuffer&&s_CurrentDrawable){
			[s_CurrentCommandBuffer presentDrawable:s_CurrentDrawable];
			CommitCurrentCommandBuffer();
			s_CurrentDrawable=nil;
		}
	}
	
	bool MetalContext::IsValid(){
		return s_Device!=nil&&s_Layer!=nil;
	}
}

