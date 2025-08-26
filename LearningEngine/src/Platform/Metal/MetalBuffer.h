#pragma once

#import "GEL/Renderer/Buffer.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
namespace GEL{
	class MetalVertexBuffer : public VertexBuffer
	{
	public:
		MetalVertexBuffer(float* vertices, uint32_t size);
		virtual ~MetalVertexBuffer() ;
		
		virtual void SetLayout(const BufferLayout& layout) override { m_Layout = layout; }
		virtual const BufferLayout& GetLayout() const override  { return m_Layout; }
		
		virtual void Bind()const override;
		virtual void Unbind()const override;

		virtual void* GetNativeBuffer()const override{return (__bridge void*)m_Buffer;}
		id<MTLBuffer> GetMetalBuffer()const {return m_Buffer;}
	private:
		uint32_t m_RendererID;
		BufferLayout m_Layout;
		uint32_t m_Size;
		id<MTLBuffer> m_Buffer;
	};
	
	class MetalIndexBuffer : public IndexBuffer
	{
	public:
		MetalIndexBuffer(uint32_t* indices, uint32_t size);
		virtual ~MetalIndexBuffer();
		
		virtual void Bind()const override;
		virtual void Unbind()const override;
		
		virtual uint32_t GetCount() const override{ return m_Count; }
		virtual void* GetNativeBuffer()const override{return (__bridge void*)m_Buffer;}
		id<MTLBuffer> GetMetalBuffer()const {return m_Buffer;}
	private:
		uint32_t m_RendererID;
		uint32_t m_Count;
		id<MTLBuffer> m_Buffer;
	};
}

