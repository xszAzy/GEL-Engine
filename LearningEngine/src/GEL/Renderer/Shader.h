#pragma once


namespace GEL
{
	class Shader
	{
	public:
		Shader(const std::string& vertexSrc,const std::string& fragmentSrc);
		~Shader();

		void Bind() const;
		void Unbind() const;//UN
	private:
		uint32_t m_RendererID;
	};
}


