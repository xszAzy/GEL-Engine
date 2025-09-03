#pragma once

#include "GEL/Layer.h"

#include "GEL/Events/KeyEvent.h"
#include "GEL/Events/MouseEvent.h"
#include "GEL/Events/ApplicationEvent.h"
#import <Metal/Metal.h>
#import <QuartzCore/QuartzCore.h>
#import <Cocoa/Cocoa.h>

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
		
#ifdef GEL_PLATFORM_MAC
		void CreateFontTexture();
		void SetupRenderState(id<MTLRenderCommandEncoder> encoder,id<MTLBuffer> vertexBuffer,id<MTLBuffer> indexBuffer,MTLViewport viewport);
	private:
		id<MTLDevice> m_Device;
		id<MTLRenderPipelineState> m_PipelineState;
		id<MTLTexture> m_FontTexture;
		id<MTLBuffer> m_VertexBuffer;
		id<MTLBuffer> m_IndexBuffer;
		NSUInteger m_VertexBufferSize;
		NSUInteger m_IndexBufferSize;
#endif
	private:
		float m_Time = 0.0f;
	};
}
