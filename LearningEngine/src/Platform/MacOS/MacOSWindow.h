#pragma once

#include "GEL/Window.h"
#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

struct Metalwindow;

namespace GEL {
	class MacOSWindow :public Window
	{
	public:
		MacOSWindow(const WindowProps& props);
		virtual ~MacOSWindow();
		
		void OnUpdate() override;
		
		inline unsigned int GetWidth() const override { return m_Data.Width; }
		inline unsigned int GetHeight()  const override { return m_Data.Height; }
		
		inline void SetEventCallback(const EventCallbackFn& Callback) override { m_Data.EventCallback = Callback; }
		const EventCallbackFn& GetEventCallback()const override {return m_Data.EventCallback;}
		
		void SetVSync(bool enabled) override;
		bool IsVSync() const override;
		
		virtual void* GetNativeWindow() const override { return m_Window; }
		id<MTLDevice> GetMetalDevice() const {return m_Device;}
		CAMetalLayer* GetMetalLayer() const {return m_MetalLayer;}
		
		void SetMetalLayer(CAMetalLayer* layer){m_MetalLayer=layer;}
	private:
		virtual void Init(const WindowProps& props);
		virtual void Shutdown();
	private:
		NSWindow* m_Window;
		NSView* m_View;
		id<MTLDevice> m_Device;
		CAMetalLayer* m_MetalLayer;
		
		struct WindowData
		{
			std::string Title;
			unsigned int Width, Height;
			bool VSync;
			
			EventCallbackFn EventCallback;
		};
		
		WindowData m_Data;
	};
	
}
