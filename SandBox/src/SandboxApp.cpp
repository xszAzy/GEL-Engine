#include<GEL.h>

class ExampleLayer : public GEL::Layer
{
public:
	
	ExampleLayer():Layer("Example")
	{

		
	}
	void OnUpdate() override {
		
	}
	void OnEvent(GEL::Event& event)override {
		//GEL_TRACE("exampleevent{0}", e.ToString());
		if (event.GetEventType() == GEL::EventType::KeyPressed)
		{
			GEL::KeyPressedEvent& e = (GEL::KeyPressedEvent&)event;
			if (e.GetKeyCode() == GEL_KEY_TAB)
				GEL_TRACE("Tab is here");
			GEL_TRACE("{0}", (char)e.GetKeyCode());
		}
	}
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
