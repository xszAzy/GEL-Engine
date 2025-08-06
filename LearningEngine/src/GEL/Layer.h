#pragma once

#include "GEL/Core.h"
#include "GEL/Events/Event.h"


namespace GEL
{
	class GEL_API Layer
	{
	public:
		Layer(const std::string& name = "Layer");
		virtual ~Layer();

		virtual void OnAttach() {}
		virtual void OnDetach() {}
		virtual void OnUpdate() {}
		virtual void OnImGuiRenderer() {}
		virtual void OnEvent(Event& event){}

		const std::string& GetName() const { return m_DebugName; }
	protected:
		std::string m_DebugName;
	};
}
