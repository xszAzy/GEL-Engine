#import "MetalContext.h"
#import <Foundation/Foundation.h>

namespace GEL{
	CAMetalLayer* MetalContext::s_Layer=nil;
	id<MTLDevice> MetalContext::s_Device=nil;
	id<MTLCommandQueue> MetalContext::s_CommandQueue=nil;
	
	MTLRenderPassDescriptor* MetalContext::s_RenderPassDescriptor=nil;
	
	void MetalContext::Init(id<MTLDevice> device,CAMetalLayer* layer){
		s_Device=device;
		s_Layer=layer;
		s_CommandQueue=[s_Device newCommandQueue];
		
		CreateRenderPassDescriptor();
	}
	
	void MetalContext::Shutdown()
	{
		s_RenderPassDescriptor=nil;
		s_CommandQueue=nil;
		s_Device=nil;
		s_Layer=nil;
	}
	
	void MetalContext::CreateRenderPassDescriptor()
	{
		s_RenderPassDescriptor=[MTLRenderPassDescriptor renderPassDescriptor];
		
		s_RenderPassDescriptor.colorAttachments[0].loadAction=MTLLoadActionClear;
		
		s_RenderPassDescriptor.colorAttachments[0].storeAction=MTLStoreActionStore;
		
		s_RenderPassDescriptor.colorAttachments[0].clearColor=MTLClearColorMake(0.3, 0.1, 0.2, 1.0);
	}
}

