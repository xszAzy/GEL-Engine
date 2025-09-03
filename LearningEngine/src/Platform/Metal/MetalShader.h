#pragma once

#import <Metal/Metal.h>
#import <string>
#include "glm/glm.hpp"
#include "GEL/Renderer/Shader.h"

namespace GEL {
	
	class MetalShader : public Shader {
	public:
		MetalShader(const std::string& vertexSrc, const std::string& fragmentSrc);
		virtual ~MetalShader();
		
		virtual void Bind() const;
		virtual void Unbind() const override;
		
		void UploadUniformInt(const std::string& name, const int value);
		void UploadUniformFloat(const std::string& name, float value);
		void UploadUniformFloat2(const std::string& name, const glm::vec2& value);
		void UploadUniformFloat3(const std::string& name, const glm::vec3& value);
		void UploadUniformFloat4(const std::string& name, const glm::vec4& value);
		void UploadUniformMat3(const std::string& name, const glm::mat3& matrix);
		void UploadUniformMat4(const std::string& name, const glm::mat4& matrix);
		
		id<MTLFunction> GetVertexFunction() const { return m_VertexFunction; }
		id<MTLFunction> GetFragmentFunction() const { return m_FragmentFunction; }
		id<MTLBuffer> GetUniformBuffer() const { return m_UniformBuffer; }
		
		void UploadUniforms(id<MTLRenderCommandEncoder> commandEncoder);
		
	private:
		void Compile(const std::string& vertexSource, const std::string& fragmentSource);
		void CreateUniformBuffer();
		void UpdateUniformBuffer();
		
		struct UniformData {
			size_t offset;
			size_t size;
			std::vector<uint8_t> data;
		};
		
	private:
		id<MTLLibrary> m_Library;
		id<MTLFunction> m_VertexFunction;
		id<MTLFunction> m_FragmentFunction;
		id<MTLBuffer> m_UniformBuffer;
		
		std::unordered_map<std::string, UniformData> m_Uniforms;
		size_t m_UniformBufferSize;
		mutable bool m_UniformsDirty;
	};
	
}
