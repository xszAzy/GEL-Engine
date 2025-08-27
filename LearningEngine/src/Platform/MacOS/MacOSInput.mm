#import "MacOSInput.h"
#import <Cocoa/Cocoa.h>
#import <Appkit/AppKit.h>
#import <Foundation/Foundation.h>

namespace GEL {
	static std::unordered_map<int, int>s_KeyMap={
		{GEL_KEY_SPACE,				0x31},
		{GEL_KEY_APOSTROPHE,		0x27},
		{GEL_KEY_COMMA,				0x2B},
		{GEL_KEY_MINUS,				0x1B},
		{GEL_KEY_PERIOD,			0x2F},
		{GEL_KEY_SLASH,				0x2C},
		{GEL_KEY_0,					0x1D},
		{GEL_KEY_1,					0x12},
		{GEL_KEY_2,					0x13},
		{GEL_KEY_3,					0x14},
		{GEL_KEY_4,					0x15},
		{GEL_KEY_5,					0x17},
		{GEL_KEY_6,					0x16},
		{GEL_KEY_7,					0x1A},
		{GEL_KEY_8,					0x1C},
		{GEL_KEY_9,					0x19},
		{GEL_KEY_SEMICOLON,			0x29},
		{GEL_KEY_EQUAL,				0x18},
		{GEL_KEY_A,					0x00},
		{GEL_KEY_B,					0x0B},
		{GEL_KEY_C,					0x08},
		{GEL_KEY_D,					0x02},
		{GEL_KEY_E,					0x0E},
		{GEL_KEY_F,					0x03},
		{GEL_KEY_G,					0x05},
		{GEL_KEY_H,					0x04},
		{GEL_KEY_I,					0x22},
		{GEL_KEY_J,					0x26},
		{GEL_KEY_K,					0x28},
		{GEL_KEY_L,					0x25},
		{GEL_KEY_M,					0x2E},
		{GEL_KEY_N,					0x2D},
		{GEL_KEY_O,					0x1F},
		{GEL_KEY_P,					0x23},
		{GEL_KEY_Q,					0x0C},
		{GEL_KEY_R,					0x0F},
		{GEL_KEY_S,					0x01},
		{GEL_KEY_T,					0x11},
		{GEL_KEY_U,					0x20},
		{GEL_KEY_V,					0x09},
		{GEL_KEY_W,					0x0D},
		{GEL_KEY_X,					0x07},
		{GEL_KEY_Y,					0x10},
		{GEL_KEY_Z,					0x06},
		{GEL_KEY_LEFT_BRACKET,		0x21},
		{GEL_KEY_BACKSLASH,			0x2A},
		{GEL_KEY_RIGHT_BRACKET,		0x1E},
		{GEL_KEY_GRAVE_ACCENT,		0x32},
		{GEL_KEY_ESCAPE,			0x35},
		{GEL_KEY_ENTER,				0x24},
		{GEL_KEY_TAB,				0x30},
		{GEL_KEY_BACKSPACE,			0x33},
		{GEL_KEY_INSERT,			0x72},
		{GEL_KEY_DELETE,			0x75},
		{GEL_KEY_RIGHT,				0x7C},
		{GEL_KEY_LEFT,				0x7B},
		{GEL_KEY_DOWN,				0x7D},
		{GEL_KEY_UP,				0x7E},
		{GEL_KEY_PAGE_UP,			0x74},
		{GEL_KEY_PAGE_DOWN,			0x79},
		{GEL_KEY_HOME,				0x73},
		{GEL_KEY_END,				0x77},
		{GEL_KEY_CAPS_LOCK,			0x39},
		{GEL_KEY_SCROLL_LOCK,		0x6B},
		{GEL_KEY_NUM_LOCK,			0x47},
		{GEL_KEY_PRINT_SCREEN,		0x69},
		{GEL_KEY_PAUSE,				0x71},
		{GEL_KEY_F1,				0x7A},
		{GEL_KEY_F2,				0x78},
		{GEL_KEY_F3,				0x63},
		{GEL_KEY_F4,				0x76},
		{GEL_KEY_F5,				0x60},
		{GEL_KEY_F6,				0x61},
		{GEL_KEY_F7,				0x62},
		{GEL_KEY_F8,				0x64},
		{GEL_KEY_F9,				0x65},
		{GEL_KEY_F10,				0x6D},
		{GEL_KEY_F11,				0x67},
		{GEL_KEY_F12,				0x6F},
		{GEL_KEY_KP_0,				0x52},
		{GEL_KEY_KP_1,				0x53},
		{GEL_KEY_KP_2,				0x54},
		{GEL_KEY_KP_3,				0x55},
		{GEL_KEY_KP_4,				0x56},
		{GEL_KEY_KP_5,				0x57},
		{GEL_KEY_KP_6,				0x58},
		{GEL_KEY_KP_7,				0x59},
		{GEL_KEY_KP_8,				0x5B},
		{GEL_KEY_KP_9,				0x5C},
		{GEL_KEY_KP_DECIMAL,		0x41},
		{GEL_KEY_KP_DIVIDE,			0x4B},
		{GEL_KEY_KP_MULTIPLY,		0x43},
		{GEL_KEY_KP_SUBTRACT,		0x4E},
		{GEL_KEY_KP_ADD,			0x45},
		{GEL_KEY_KP_ENTER,			0x4C},
		{GEL_KEY_KP_EQUAL,			0x51},
		{GEL_KEY_LEFT_SHIFT,		0x38},
		{GEL_KEY_LEFT_CONTROL,		0x3B},
		{GEL_KEY_LEFT_ALT,			0x3A},
		{GEL_KEY_LEFT_SUPER,		0x37},
		{GEL_KEY_RIGHT_SHIFT,		0x3C},
		{GEL_KEY_RIGHT_CONTROL,		0x3E},
		{GEL_KEY_RIGHT_ALT,			0x3D},
		{GEL_KEY_RIGHT_SUPER,		0x36},
		{GEL_KEY_MENU,				0x6E}
	};
	static std::unordered_map<int, int>s_ReverseKeyMap={
		{GEL_KEY_SPACE,				0x31},
		{GEL_KEY_APOSTROPHE,		0x27},
		{GEL_KEY_COMMA,				0x2B},
		{GEL_KEY_MINUS,				0x1B},
		{GEL_KEY_PERIOD,			0x2F},
		{GEL_KEY_SLASH,				0x2C},
		{GEL_KEY_0,					0x1D},
		{GEL_KEY_1,					0x12},
		{GEL_KEY_2,					0x13},
		{GEL_KEY_3,					0x14},
		{GEL_KEY_4,					0x15},
		{GEL_KEY_5,					0x17},
		{GEL_KEY_6,					0x16},
		{GEL_KEY_7,					0x1A},
		{GEL_KEY_8,					0x1C},
		{GEL_KEY_9,					0x19},
		{GEL_KEY_SEMICOLON,			0x29},
		{GEL_KEY_EQUAL,				0x18},
		{GEL_KEY_A,					0x00},
		{GEL_KEY_B,					0x0B},
		{GEL_KEY_C,					0x08},
		{GEL_KEY_D,					0x02},
		{GEL_KEY_E,					0x0E},
		{GEL_KEY_F,					0x03},
		{GEL_KEY_G,					0x05},
		{GEL_KEY_H,					0x04},
		{GEL_KEY_I,					0x22},
		{GEL_KEY_J,					0x26},
		{GEL_KEY_K,					0x28},
		{GEL_KEY_L,					0x25},
		{GEL_KEY_M,					0x2E},
		{GEL_KEY_N,					0x2D},
		{GEL_KEY_O,					0x1F},
		{GEL_KEY_P,					0x23},
		{GEL_KEY_Q,					0x0C},
		{GEL_KEY_R,					0x0F},
		{GEL_KEY_S,					0x01},
		{GEL_KEY_T,					0x11},
		{GEL_KEY_U,					0x20},
		{GEL_KEY_V,					0x09},
		{GEL_KEY_W,					0x0D},
		{GEL_KEY_X,					0x07},
		{GEL_KEY_Y,					0x10},
		{GEL_KEY_Z,					0x06},
		{GEL_KEY_LEFT_BRACKET,		0x21},
		{GEL_KEY_BACKSLASH,			0x2A},
		{GEL_KEY_RIGHT_BRACKET,		0x1E},
		{GEL_KEY_GRAVE_ACCENT,		0x32},
		{GEL_KEY_ESCAPE,			0x35},
		{GEL_KEY_ENTER,				0x24},
		{GEL_KEY_TAB,				0x30},
		{GEL_KEY_BACKSPACE,			0x33},
		{GEL_KEY_INSERT,			0x72},
		{GEL_KEY_DELETE,			0x75},
		{GEL_KEY_RIGHT,				0x7C},
		{GEL_KEY_LEFT,				0x7B},
		{GEL_KEY_DOWN,				0x7D},
		{GEL_KEY_UP,				0x7E},
		{GEL_KEY_PAGE_UP,			0x74},
		{GEL_KEY_PAGE_DOWN,			0x79},
		{GEL_KEY_HOME,				0x73},
		{GEL_KEY_END,				0x77},
		{GEL_KEY_CAPS_LOCK,			0x39},
		{GEL_KEY_SCROLL_LOCK,		0x6B},
		{GEL_KEY_NUM_LOCK,			0x47},
		{GEL_KEY_PRINT_SCREEN,		0x69},
		{GEL_KEY_PAUSE,				0x71},
		{GEL_KEY_F1,				0x7A},
		{GEL_KEY_F2,				0x78},
		{GEL_KEY_F3,				0x63},
		{GEL_KEY_F4,				0x76},
		{GEL_KEY_F5,				0x60},
		{GEL_KEY_F6,				0x61},
		{GEL_KEY_F7,				0x62},
		{GEL_KEY_F8,				0x64},
		{GEL_KEY_F9,				0x65},
		{GEL_KEY_F10,				0x6D},
		{GEL_KEY_F11,				0x67},
		{GEL_KEY_F12,				0x6F},
		{GEL_KEY_KP_0,				0x52},
		{GEL_KEY_KP_1,				0x53},
		{GEL_KEY_KP_2,				0x54},
		{GEL_KEY_KP_3,				0x55},
		{GEL_KEY_KP_4,				0x56},
		{GEL_KEY_KP_5,				0x57},
		{GEL_KEY_KP_6,				0x58},
		{GEL_KEY_KP_7,				0x59},
		{GEL_KEY_KP_8,				0x5B},
		{GEL_KEY_KP_9,				0x5C},
		{GEL_KEY_KP_DECIMAL,		0x41},
		{GEL_KEY_KP_DIVIDE,			0x4B},
		{GEL_KEY_KP_MULTIPLY,		0x43},
		{GEL_KEY_KP_SUBTRACT,		0x4E},
		{GEL_KEY_KP_ADD,			0x45},
		{GEL_KEY_KP_ENTER,			0x4C},
		{GEL_KEY_KP_EQUAL,			0x51},
		{GEL_KEY_LEFT_SHIFT,		0x38},
		{GEL_KEY_LEFT_CONTROL,		0x3B},
		{GEL_KEY_LEFT_ALT,			0x3A},
		{GEL_KEY_LEFT_SUPER,		0x37},
		{GEL_KEY_RIGHT_SHIFT,		0x3C},
		{GEL_KEY_RIGHT_CONTROL,		0x3E},
		{GEL_KEY_RIGHT_ALT,			0x3D},
		{GEL_KEY_RIGHT_SUPER,		0x36},
		{GEL_KEY_MENU,				0x6E}
	};
	static std::unordered_map<int, int>s_MouseButtonMap={
		{GEL_MOUSE_BUTTON_1,         0},
		{GEL_MOUSE_BUTTON_2,         1},
		{GEL_MOUSE_BUTTON_3,         2},
		{GEL_MOUSE_BUTTON_4,         3},
		{GEL_MOUSE_BUTTON_5,         4},
		{GEL_MOUSE_BUTTON_6,         5},
		{GEL_MOUSE_BUTTON_7,         6},
		{GEL_MOUSE_BUTTON_8,         7}
	};
	bool MacOSInput::IsKeyPressedImpl(int keycode){
		auto it = s_KeyMap.find(keycode);
		if(it==s_MouseButtonMap.end())
			return false;
		int macKeyCode=it->second;
		
		CGEventRef event=CGEventCreate(NULL);
		CGKeyCode keyCode=static_cast<CGKeyCode>(macKeyCode);
		bool isPressed=CGEventSourceKeyState(kCGEventSourceStateHIDSystemState, keyCode);
		CFRelease(event);
		
		return isPressed;
	}
	bool MacOSInput::IsMouseButtonPressedImpl(int button){
		
		auto it=s_MouseButtonMap.find(button);
		if(it == s_MouseButtonMap.end())
			return false;
		int macButton=it->second;
		
		CGEventRef event=CGEventCreate(NULL);
		bool isPressed=CGEventSourceButtonState(kCGEventSourceStateHIDSystemState,static_cast<CGMouseButton>(macButton));
		CFRelease(event);
		
		return isPressed;
	}
	
	std::pair<float, float> MacOSInput::GetMousePositionImpl(){
		CGEventRef event=CGEventCreate(NULL);
		CGPoint cursor=CGEventGetLocation(event);
		CFRelease(event);
		
		return {static_cast<float>(cursor.x),static_cast<float>(cursor.y)};
	}
	
	float MacOSInput::GetMouseXImpl(){
		auto [x, y] = GetMousePositionImpl();
		return (float)x;
	}
	
	float MacOSInput::GetMouseYImpl(){
		auto [x, y] = GetMousePositionImpl();
		return (float)y;
	}
}
