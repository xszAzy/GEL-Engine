#pragma once

#include "GEL/Input.h"
#include "GEL/KeyCodes.h"
#include "GEL/MouseButtonCodes.h"

namespace GEL
{
	class MacOSInput : public Input{
	protected:
		virtual bool IsKeyPressedImpl(int keycode) override;
		virtual bool IsMouseButtonPressedImpl(int button) override;
		virtual std::pair<float, float> GetMousePositionImpl() override;
		virtual float GetMouseXImpl() override;
		virtual float GetMouseYImpl() override;
	};
}
