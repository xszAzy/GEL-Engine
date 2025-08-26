#pragma once

#include "GEL/Core.h"
#include "GEL/Events/Event.h"
#include "GEL/Core/TimeStep.h"

namespace GEL
{
	class Layer
	{
	public:
		Layer(const std::string& name = "Layer");
		virtual ~Layer();

		virtual void OnAttach() {}
		virtual void OnDetach() {}
		virtual void OnUpdate(Timestep ts) {}
		virtual void OnImGuiRenderer() {}
		virtual void OnEvent(Event& event){}

		const std::string& GetName() const { return m_DebugName; }
	protected:
		std::string m_DebugName;
	};
}
