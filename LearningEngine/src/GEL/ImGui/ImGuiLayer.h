#pragma once

#include "GEL/Layer.h"

#include "GEL/Events/KeyEvent.h"
#include "GEL/Events/MouseEvent.h"
#include "GEL/Events/ApplicationEvent.h"

namespace GEL {
	class GEL_API ImGuiLayer :public Layer
	{
	public:
		ImGuiLayer();
		~ImGuiLayer();

		virtual void OnAttach()override;
		virtual void OnDetach()override;
		virtual void OnImGuiRenderer()override;
		void Begin();
		void End();
	private:
		float m_Time = 0.0f;
	};
}
