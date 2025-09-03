#import "MetalShader.h"
#import "MetalContext.h"
#import "GEL/Log.h"
#import <vector>

namespace GEL {
	
	MetalShader::MetalShader(const std::string& vertexSrc, const std::string& fragmentSrc) {
		m_UniformBufferSize = 1024;
		m_UniformsDirty = false;
		
		Compile(vertexSrc, fragmentSrc);
		CreateUniformBuffer();
	}
	
	MetalShader::~MetalShader() {
		@autoreleasepool {
			m_VertexFunction = nil;
			m_FragmentFunction = nil;
			m_Library = nil;
			m_UniformBuffer = nil;
		}
	}
	
	void MetalShader::Compile(const std::string& vertexSource, const std::string& fragmentSource) {
		id<MTLDevice> device = MetalContext::GetDevice();
		if (!device) {
			GEL_CORE_ERROR("No Metal device available for shader compilation");
			return;
		}
		
		@autoreleasepool {
			NSError* error = nil;
			
			std::string metalSource = R"(
#include <metal_stdlib>
using namespace metal;
)" +
			vertexSource +
			"\n" +
			fragmentSource;
			
			m_Library = [device newLibraryWithSource:@(metalSource.c_str())
											 options:nil
											   error:&error];
			
			if (error) {
				GEL_CORE_ERROR("Failed to compile Metal shader: {0}", [[error localizedDescription] UTF8String]);
				return;
			}
			
			m_VertexFunction = [[m_Library newFunctionWithName:@"vertexMain"] retain];
			if (!m_VertexFunction) {
				m_VertexFunction = [[m_Library newFunctionWithName:@"vertexShader"] retain];
			}
			
			m_FragmentFunction = [[m_Library newFunctionWithName:@"fragmentMain"] retain];
			if (!m_FragmentFunction) {
				m_FragmentFunction = [[m_Library newFunctionWithName:@"fragmentShader"] retain];
			}
			
			if (!m_VertexFunction || !m_FragmentFunction) {
				GEL_CORE_ERROR("Failed to find vertex/fragment functions in shader library");
				return;
			}
			
			GEL_CORE_INFO("Metal shader compiled successfully");
		}
	}
	
	void MetalShader::CreateUniformBuffer() {
		id<MTLDevice> device = MetalContext::GetDevice();
		if (device) {
			m_UniformBuffer = [device newBufferWithLength:m_UniformBufferSize
												  options:MTLResourceStorageModeShared];
			m_UniformBuffer.label = @"GEL_UniformBuffer";
		}
	}
	
	void MetalShader::Bind() const{
		m_UniformsDirty=true;
	}
	
	void MetalShader::Unbind() const {
	}
	
	void MetalShader::UploadUniformInt(const std::string& name, const int value) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(int);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &value, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UploadUniformFloat(const std::string& name, float value) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(float);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &value, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UploadUniformFloat2(const std::string& name, const glm::vec2& value) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(glm::vec2);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &value, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UploadUniformFloat3(const std::string& name, const glm::vec3& value) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(glm::vec3);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &value, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UploadUniformFloat4(const std::string& name, const glm::vec4& value) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(glm::vec4);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &value, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UploadUniformMat3(const std::string& name, const glm::mat3& matrix) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(glm::mat3);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &matrix, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UploadUniformMat4(const std::string& name, const glm::mat4& matrix) {
		UniformData& uniform = m_Uniforms[name];
		uniform.size = sizeof(glm::mat4);
		uniform.data.resize(uniform.size);
		memcpy(uniform.data.data(), &matrix, uniform.size);
		m_UniformsDirty = true;
	}
	
	void MetalShader::UpdateUniformBuffer() {
		if (!m_UniformBuffer || !m_UniformsDirty) {
			return;
		}
		
		void* bufferContents = [m_UniformBuffer contents];
		size_t currentOffset = 0;
		
		for (auto& [name, uniform] : m_Uniforms) {
			if (currentOffset + uniform.size > m_UniformBufferSize) {
				GEL_CORE_ERROR("Uniform buffer overflow!");
				break;
			}
			
			memcpy(static_cast<char*>(bufferContents) + currentOffset, uniform.data.data(), uniform.size);
			uniform.offset = currentOffset;
			currentOffset += uniform.size;
		}
		
		m_UniformsDirty = false;
	}
	
	void MetalShader::UploadUniforms(id<MTLRenderCommandEncoder> commandEncoder) {
		if (!commandEncoder) {
			return;
		}
		
		UpdateUniformBuffer();
		
		if (m_UniformBuffer) {
			[commandEncoder setVertexBuffer:m_UniformBuffer offset:0 atIndex:1];
			[commandEncoder setFragmentBuffer:m_UniformBuffer offset:0 atIndex:1];
		}
	}
	
}
