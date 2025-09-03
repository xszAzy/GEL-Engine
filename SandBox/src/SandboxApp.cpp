#include "GEL.h"

#include "Platform/Metal/MetalShader.h"

#include "../imgui/imgui.h"

#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"

class ExampleLayer : public GEL::Layer
{
public:
	
	ExampleLayer():Layer("Example"),m_Camera(-1.0f,1.0f,-1.0f,1.0f),m_CameraPosition(0.0f),m_SquarePosition(0.0f)
	{
		m_VertexArray.reset(GEL::VertexArray::Create());
		
		//-1 : 1
		float vertices[3 * 7] = {
			-0.5f, -0.5f, 0.0f,.7f, .3f, .9f, 1.0f,
			0.5f, -0.5f, 0.0f,0.1f, 0.2f, 0.7f, 1.0f,
			0.0f,  0.5f, 0.0f,.8f, .9f, 0.1f, 1.0f
		};
		std::shared_ptr<GEL::VertexBuffer> vertexbuffer;
		vertexbuffer.reset(GEL::VertexBuffer::Create(vertices,sizeof(vertices)));
		GEL::BufferLayout layout = {
			{ GEL::ShaderDataType::Float3,"a_Position"},
			{ GEL::ShaderDataType::Float4,"a_Color"}
		};
		vertexbuffer->SetLayout(layout);
		m_VertexArray->AddVertexBuffer(vertexbuffer);
		
		uint32_t indices[3] = { 0,1,2 };
		std::shared_ptr<GEL::IndexBuffer> indexbuffer;
		indexbuffer.reset(GEL::IndexBuffer::Create(indices, sizeof(indices)/sizeof(uint32_t)));
		m_VertexArray->SetIndexBuffer(indexbuffer);
		
		m_SquareVA.reset(GEL::VertexArray::Create());
		
		float squareVertices[3 * 4] = {
			-0.5f, -0.5f, 0.0f,
			0.5f, -0.5f, 0.0f,
			0.5f,  0.5f, 0.0f,
			-0.5f,  0.5f, 0.0f
		};
		
		std::shared_ptr<GEL::VertexBuffer> squareVB;
		squareVB.reset(GEL::VertexBuffer::Create(squareVertices,sizeof(squareVertices)));
		vertexbuffer->SetLayout({
			{ GEL::ShaderDataType::Float3,"a_Position"}
		});
		m_SquareVA->AddVertexBuffer(squareVB);
		
		uint32_t squareIndices[6] = { 0,1,2,2,3,0 };
		std::shared_ptr<GEL::IndexBuffer> squareIB;
		squareIB.reset(GEL::IndexBuffer::Create(indices, sizeof(squareIndices)/sizeof(uint32_t)));
		m_VertexArray->SetIndexBuffer(indexbuffer);
	/*opengl
		std::string vertexSrc = R"(
   #version 330 core
   layout(location=0) in vec3 a_Position;
   layout(location=1) in vec4 a_Color;
  
   uniform mat4 u_ViewProjection;
   uniform mat4 u_Transform;
  
   out vec3 v_Position;
   out vec4 v_Color;
   void main()
   {
   v_Position = a_Position;
   v_Color = a_Color;	
   gl_Position =u_ViewProjection*u_Transform*vec4(a_Position+0.3,1.0);
   }
  )";
		std::string fragmentSrc = R"(
   #version 330 core
   layout(location=0) out vec4 color;
   in vec3 v_Position;
   in vec4 v_Color;
   void main()
   {
   color =vec4(v_Position*0.3+0.3,1.0);
   color = v_Color;
   }
  )";
		*/
		std::string vertexSrc=R"(
#include <metal_stdlib>
using namespace metal;

struct VertexIn{
	float3 position [[attribute(0)]];
	float4 color [[attribute(1)]];
};

struct VertexOut{
	float4 position [[position]];
	float4 color;
	float3 worldPosition;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]],constant float4x4& u_Transform [[buffer(2)]]){
	VertexOut out;

	float4 worldPosition=u_Transform*float4(in.position,1.0);
	out.position=u_ViewProjection*worldPosition;
	out.color=in.color;
	out.worldPosition=worldPosition.xyz;

	return out;
}
)";
		
		std::string fragmentSrc=R"(
#include <metal_stdlib>
using namespace metal;

fragment float4 fragment_main(VertexOut in [[stage_in]]){
	float3 color=in.worldPosition*0.3;
	return float4(color,1.0);
	return in.color;
}
)";
		m_Shader.reset(GEL::Shader::Create(vertexSrc,fragmentSrc));
/*
		std::string vertexSrc2 = R"(
   #version 330 core
   layout(location=0) in vec3 a_Position;
  
   uniform mat4 u_ViewProjection;
   uniform mat4 u_Transform;
  
   out vec3 v_Position;
   void main()
   {
	v_Position = a_Position;
	gl_Position =u_ViewProjection*u_Transform*vec4(a_Position+0.3,1.0);
   }
  )";
		std::string fragmentSrc2 = R"(
   #version 330 core
   layout(location=0) out vec4 color;
  
   uniform vec3 u_Color;
  
   in vec3 v_Position;
   void main()
   {
	color =vec4(u_Color,1.0);
   }
  )";
		m_NewShader.reset(GEL::Shader::Create(vertexSrc2,fragmentSrc2));
		*/
	}
	void OnUpdate(GEL::Timestep ts) override {
		GEL_TRACE("Delta Time: {0}s ({1})",ts.GetSeconds(),ts.GetMilliSeconds());
		
		if(GEL::Input::IsKeyPressed(GEL_KEY_LEFT))
			m_CameraPosition.x -= m_CameraMoveSpeed*ts;
		else if(GEL::Input::IsKeyPressed(GEL_KEY_RIGHT))
			m_CameraPosition.x += m_CameraMoveSpeed*ts;
		
		if(GEL::Input::IsKeyPressed(GEL_KEY_DOWN))
			m_CameraPosition.y -= m_CameraMoveSpeed*ts;
		else if(GEL::Input::IsKeyPressed(GEL_KEY_UP))
			m_CameraPosition.y += m_CameraMoveSpeed*ts;
		
		if(GEL::Input::IsKeyPressed(GEL_KEY_D))
			m_CameraRotation -= m_CameraRotationSpeed*ts;
		else if(GEL::Input::IsKeyPressed(GEL_KEY_A))
			m_CameraRotation += m_CameraRotationSpeed*ts;
		
		if(GEL::Input::IsKeyPressed(GEL_KEY_J))
			m_SquarePosition.x -= m_SquareMoveSpeed*ts;
		else if(GEL::Input::IsKeyPressed(GEL_KEY_L))
			m_SquarePosition.x += m_SquareMoveSpeed*ts;
		
		if(GEL::Input::IsKeyPressed(GEL_KEY_K))
			m_SquarePosition.y -= m_SquareMoveSpeed*ts;
		else if(GEL::Input::IsKeyPressed(GEL_KEY_I))
			m_SquarePosition.y += m_SquareMoveSpeed*ts;
		
		
		GEL::RenderCommand::SetClearColor({0.1f, 0.1f, 0.1f, 1});
		GEL::RenderCommand::Clear();
		
		m_Camera.SetPosition(m_CameraPosition);
		m_Camera.SetRotation(m_CameraRotation);
		
		GEL::Renderer::BeginScene(m_Camera);

		glm::mat4 scale = glm::scale(glm::mat4(1.0f),glm::vec3(0.1f));
		
		//GEL::MaterialRef material = new GEL::Material(m_NewShader);
		//GEL::MaterialInstanceRef mi = new GEL::MaterialInstance(material);
		
		//mi->SetValue("u_Color",redColor);
		//mi->SetTexture("u_AlbedoMap",texture);
		//squareMesh->SetMaterial(mi);
		
		std::dynamic_pointer_cast<GEL::MetalShader>(m_NewShader)->Bind();
		std::dynamic_pointer_cast<GEL::MetalShader>(m_NewShader)->UploadUniformFloat3("u_Color", m_SquareColor);
		
		for (int i=0;i<20;i++)
		{
			for(int j=0;j<5;j++)
			{
				glm::vec3 pos(j*0.11f,i*0.11f,0.0f);
				glm::mat4 transform = glm::translate(glm::mat4(1.0f),pos)*scale;
				GEL::Renderer::Submit(m_NewShader,m_SquareVA,transform);
			}
		}
		
		GEL::Renderer::Submit(m_Shader,m_VertexArray);
		
		GEL::Renderer::EndScene();
		
	}
	virtual void OnImGuiRenderer() override{
		ImGui::Begin("Settings");
		ImGui::ColorEdit3("SquareColor", glm::value_ptr(m_SquareColor));
		ImGui::End();
	}
	void OnEvent(GEL::Event& event)override {
		
	}
private:
	std::shared_ptr<GEL::Shader> m_Shader;
	std::shared_ptr<GEL::VertexArray> m_VertexArray;
	
	std::shared_ptr<GEL::Shader> m_NewShader;
	std::shared_ptr<GEL::VertexArray> m_SquareVA;
	
	GEL::OrthographicCamera m_Camera;
	glm::vec3 m_CameraPosition;
	float m_CameraMoveSpeed=5.0f;
	float m_CameraRotation=.0f;
	float m_CameraRotationSpeed=180.0f;
	
	glm::vec3 m_SquarePosition;
	float m_SquareMoveSpeed=5.0f;
	
	glm::vec3 m_SquareColor = {0.2f,0.3f,0.8f};
};

class Sandbox :public GEL::Application
{
public:
	Sandbox()
	{
		PushLayer(new ExampleLayer());
		//PushLayer(new GEL::ImGuiLayer());
	};
	~Sandbox()
	{
	};

};
GEL::Application* GEL::CreateApplication()
{			
	return new Sandbox();
}
