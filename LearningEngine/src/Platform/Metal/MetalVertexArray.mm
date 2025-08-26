#include "MetalVertexArray.h"
#include "MetalContext.h"
#import <Foundation/Foundation.h>
#include "GEL/Renderer/Renderer.h"

namespace GEL{
	MetalVertexArray::MetalVertexArray()
	:m_VertexDescriptor(nil)
	{
		CreateVertexDescriptor();
	}
	MetalVertexArray::~MetalVertexArray()
	{
		if(m_VertexDescriptor){
			[m_VertexDescriptor release];
			m_VertexDescriptor=nil;
		}
	}
	void MetalVertexArray::Bind() const
	{
	}
	void MetalVertexArray::Unbind() const
	{
	}
	void MetalVertexArray::AddVertexBuffer(const std::shared_ptr<VertexBuffer>& vertexBuffer)
	{
		GEL_CORE_ASSERT(vertexBuffer->GetLayout().GetElements().size(), "Vertex Buffer has no layout!");
		
		m_VertexBuffers.push_back(vertexBuffer);
		
		CreateVertexDescriptor();
	}
	void MetalVertexArray::SetIndexBuffer(const std::shared_ptr<IndexBuffer>& indexBuffer)
	{
		m_IndexBuffer = indexBuffer;
	}
	void MetalVertexArray::CreateVertexDescriptor()
	{
		if(m_VertexDescriptor){
			[m_VertexDescriptor release];
			m_VertexDescriptor=nil;
		}
		
		m_VertexDescriptor=[[MTLVertexDescriptor alloc] init];
		
		uint32_t bufferIndex=0;
		uint32_t attributeIndex=0;
		
		for(const auto& vertexBuffer :m_VertexBuffers){
			const auto& layout=vertexBuffer->GetLayout();
			
			m_VertexDescriptor.layouts[bufferIndex].stride=layout.GetStride();
			m_VertexDescriptor.layouts[bufferIndex].stepFunction=MTLVertexStepFunctionPerVertex;
			
			for(const auto& element : layout){
				MTLVertexFormat format;
				switch(element.Type)
				{
					case ShaderDataType::Float:		format=MTLVertexFormatFloat	;	break;
					case ShaderDataType::Float2:	format=MTLVertexFormatFloat2;	break;
					case ShaderDataType::Float3:	format=MTLVertexFormatFloat3;	break;
					case ShaderDataType::Float4:	format=MTLVertexFormatFloat4;	break;
					case ShaderDataType::Int:		format=MTLVertexFormatInt	;	break;
					case ShaderDataType::Int2:		format=MTLVertexFormatInt2	;	break;
					case ShaderDataType::Int3:		format=MTLVertexFormatInt3	;	break;
					case ShaderDataType::Int4:		format=MTLVertexFormatInt4	;	break;
					case ShaderDataType::Mat3:
						for(uint32_t i=0;i<3;i++){
							m_VertexDescriptor.attributes[attributeIndex].format=MTLVertexFormatFloat3;
							m_VertexDescriptor.attributes[attributeIndex].offset=element.Offset+(i*sizeof(float)*3);
							m_VertexDescriptor.attributes[attributeIndex].bufferIndex=bufferIndex;
							attributeIndex++;
						}	;	continue;
					case ShaderDataType::Mat4:
						for(uint32_t i=0;i<4;i++){
							m_VertexDescriptor.attributes[attributeIndex].format=MTLVertexFormatFloat4;
							m_VertexDescriptor.attributes[attributeIndex].offset=element.Offset+(i*sizeof(float)*4);
							m_VertexDescriptor.attributes[attributeIndex].bufferIndex=bufferIndex;
							attributeIndex++;
						}	;	continue;
					case ShaderDataType::Bool:		format=MTLVertexFormatInt	;	break;
					default:
						GEL_CORE_ERROR("Unknown shader data type!");
						format=MTLVertexFormatFloat;
						break;
				}
				m_VertexDescriptor.attributes[attributeIndex].format=format;
				m_VertexDescriptor.attributes[attributeIndex].offset=element.Offset;
				m_VertexDescriptor.attributes[attributeIndex].bufferIndex=bufferIndex;
				attributeIndex++;
			}
			bufferIndex++;
		}
	}
	
	void MetalVertexArray::BindVertexBuffers(id<MTLRenderCommandEncoder> commandEncoder)const{
		uint32_t bufferIndex=0;
		for(const auto& vertexBuffer:m_VertexBuffers){
			auto metalVB=std::static_pointer_cast<MetalVertexBuffer>(vertexBuffer);
			[commandEncoder setVertexBuffer:metalVB->GetMetalBuffer() offset:0 atIndex:bufferIndex];
			bufferIndex++;
		}
	}
}
