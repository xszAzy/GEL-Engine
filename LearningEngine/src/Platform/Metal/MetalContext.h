#pragma once

#import <Metal/Metal.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#include <cstdint>
#include "glm/glm.hpp"
#include "GEL/Renderer/GraphicsContext.h"

namespace GEL {
	class MetalContext :public GraphicsContext
	{
	public:
		static void Init(id<MTLDevice> device,CAMetalLayer* layer) ;
		static void Shutdown() ;
		
		static id<MTLDevice> GetDevice(){return s_Device;}
		static id<MTLCommandQueue> GetCommandQueue(){return s_CommandQueue;}
		static CAMetalLayer* GetLayer(){return s_Layer;}
		
		static id<MTLCommandBuffer> GetCurrentCommandBuffer();
		static id<MTLCommandBuffer> CreateNewCommandBuffer();
		static void CommitCurrentCommandBuffer();
		
		static id<CAMetalDrawable> GetCurrentDrawable();
		
		static void CreateRenderPassDescriptor();
		static MTLRenderPassDescriptor* GetRenderPassDescriptor(){return s_RenderPassDescriptor;}
		static void UpdateRenderPassDescriptorWithCurrentDrawable();
	
		static MTLPixelFormat GetDrawablePixelFormat(){return s_PixelFormat;}
		static bool IsValid(){return s_Device!=nil&&s_Layer!=nil;}
	private:
		static CAMetalLayer* s_Layer;
		static id<MTLDevice> s_Device;
		static id<MTLCommandQueue> s_CommandQueue;
		static id<MTLCommandBuffer> s_CurrentCommandBuffer;
		static id<CAMetalDrawable> s_CurrentDrawable;
		
		static MTLRenderPassDescriptor* s_RenderPassDescriptor;
		static MTLPixelFormat s_PixelFormat;
	};
}
