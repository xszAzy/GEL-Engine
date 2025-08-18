#pragma once

#include "glm/glm.hpp"

namespace GEL
{
	class Shader
	{
	public:
		Shader(const std::string& vertexSrc,const std::string& fragmentSrc);
		~Shader();

		void Bind() const;
		void Unbind() const;//UN
		
		void UploadUniformMat4(const std::string& name,const glm::mat4& matrix);
	private:
		uint32_t m_RendererID;
	};
}


