#include "MetalBuffer.h"
#import <Foundation/Foundation.h>
#import "MetalContext.h"
namespace GEL {
	/////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////VertexBuffer/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	MetalVertexBuffer::MetalVertexBuffer(float* vertices, uint32_t size):m_Size(size)
	{
		id<MTLDevice> device= MetalContext::GetDevice();
		m_Buffer=[device newBufferWithBytes:vertices length:size options:MTLResourceStorageModeShared];
		m_Buffer.label=@"GEL Vertex Buffer";
		if(!device){
			GEL_CORE_ERROR("No Metal Device available when creating vertex buffer.");
			return;
		}
	}
	MetalVertexBuffer::~MetalVertexBuffer()
	{
		m_Buffer=nil;
	}

	/////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////IndexBuffer//////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	MetalIndexBuffer::MetalIndexBuffer(uint32_t* indices, uint32_t count):m_Count(count)
	{
		uint32_t size =count* sizeof(uint32_t);
		id<MTLDevice> device= MetalContext::GetDevice();
		m_Buffer=[device newBufferWithBytes:indices length:size options:MTLResourceStorageModeShared];
		m_Buffer.label=@"GEL Index Buffer";
		if(!device){
			GEL_CORE_ERROR("No Metal Device available when creating index buffer.");
			return;
		}
	}
	MetalIndexBuffer::~MetalIndexBuffer()
	{
		m_Buffer=nil;
	}
}
