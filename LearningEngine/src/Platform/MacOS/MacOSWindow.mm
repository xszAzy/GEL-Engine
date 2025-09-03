#include "MacOSWindow.h"
#import <Foundation/Foundation.h>
#include "GEL/Events/ApplicationEvent.h"
#include "GEL/Events/MouseEvent.h"
#include "GEL/Events/KeyEvent.h"

@interface GELWindowDelegate:
NSObject <NSWindowDelegate>
{
	GEL::MacOSWindow* m_Window;
}

-(instancetype)initWithWindow:
(GEL::MacOSWindow*)window;

@end

@implementation GELWindowDelegate

-(instancetype)initWithWindow:(GEL::MacOSWindow *)window
{
	self = [super init];
	if (self != nil)
	{
		m_Window = window;
	}
	return self;
}

-(void)windowWillClose:(NSNotification*)notification
{
	GEL::WindowCloseEvent event;
	m_Window->GetEventCallback()(event);
}

-(void)windowDidResize:(NSNotification *)notification
{
	NSWindow* window =[notification object];
	NSSize size = [window contentRectForFrameRect:[window frame]].size;
	CGFloat scale = [window backingScaleFactor];
	
	unsigned int width = size.width * scale;
	unsigned int height =size.height *scale;
	
	GEL::WindowResizeEvent event(width, height);
	m_Window->GetEventCallback()(event);
}

@end

@interface GELContentView:
NSView
{
	GEL::MacOSWindow* m_Window;
	NSTrackingArea* m_TrackingArea;
}

-(instancetype)initWithWindow:
(GEL::MacOSWindow*)window;

@end

@implementation GELContentView

-(instancetype)initWithWindow:(GEL::MacOSWindow *)window
{
	self = [super init];
	if(self !=nil)
	{
		m_Window=window;
		[self SetupMetalLayer];
	}
	return self;
}

-(void)SetupMetalLayer
{
	CAMetalLayer* metalLayer =[CAMetalLayer layer];
	metalLayer.device=m_Window->GetMetalDevice();
	metalLayer.pixelFormat=MTLPixelFormatBGRA8Unorm;
	metalLayer.framebufferOnly=YES;
	metalLayer.contentsScale=[[NSScreen mainScreen]backingScaleFactor];
	
	self.layer=metalLayer;
	self.wantsLayer=YES;
	
	m_Window->SetMetalLayer(metalLayer);
}

-(BOOL)acceptsFirstResponder
{
	return YES;
}

-(BOOL)canBecomeKeyView
{
	return YES;
}

-(void)updateTrackingAreas
{
	if(m_TrackingArea != nil){
		[self removeTrackingArea:m_TrackingArea];
		m_TrackingArea = nil;
	}
	
	NSTrackingAreaOptions options =
	NSTrackingMouseMoved |
	NSTrackingInVisibleRect |
	NSTrackingActiveAlways;
	m_TrackingArea = [[NSTrackingArea alloc]initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:m_TrackingArea];
}

-(void)mouseDown:(NSEvent *)event
{
	GEL::MouseButtonPressedEvent e((int)[event buttonNumber]);
	m_Window->GetEventCallback()(e);
}

-(void)mouseUp:(NSEvent *)event
{
	GEL::MouseButtonReleasedEvent e((int)[event buttonNumber]);
	m_Window->GetEventCallback()(e);
}

-(void)mouseDragged:(NSEvent *)event
{
	NSPoint point=[self convertPoint:[event locationInWindow] fromView:nil];
	point.y =self.bounds.size.height-point.y;
	
	GEL::MouseMovedEvent e(point.x,point.y);
	m_Window->GetEventCallback()(e);
}

-(void)mouseMoved:(NSEvent *)event
{
	NSPoint point=[self convertPoint:[event locationInWindow] fromView:nil];
	point.y =self.bounds.size.height-point.y;
	
	GEL::MouseMovedEvent e(point.x,point.y);
	m_Window->GetEventCallback()(e);
}

-(void)keyDown:(NSEvent *)event
{
	int KeyCode=[event keyCode];
	GEL::KeyPressedEvent e(KeyCode,0);
	m_Window->GetEventCallback()(e);
}

-(void)keyUp:(NSEvent *)event
{
	int KeyCode=[event keyCode];
	GEL::KeyReleasedEvent e(KeyCode);
	m_Window->GetEventCallback()(e);
}

-(void)flagsChanged:(NSEvent *)event
{
	NSEventModifierFlags flags=[event modifierFlags];
	int keyCode=[event keyCode];
	
	static NSEventModifierFlags s_PreviousFlags=0;
	
	if((flags&NSEventModifierFlagShift)!=(s_PreviousFlags&NSEventModifierFlagShift)){
		GEL::KeyEvent* e =(flags&NSEventModifierFlagShift)?(GEL::KeyEvent*)new GEL::KeyPressedEvent(0x38,0):
		(GEL::KeyEvent*)new GEL::KeyPressedEvent(0x3C,0);
		m_Window->GetEventCallback()(*e);
		delete e;
	}
	s_PreviousFlags=flags;
}
@end

namespace GEL
{
	MacOSWindow::MacOSWindow(const WindowProps& props)
	{
		Init(props);
	}
	
	MacOSWindow::~MacOSWindow() {
		Shutdown();
	}
	Window* Window::CreateMacOSWindow(const WindowProps& props){
		return new MacOSWindow(props);
	}
	void MacOSWindow::Init(const WindowProps& props)
	{
		m_Data.Title = props.Title;
		m_Data.Width = props.Width;
		m_Data.Height = props.Height;
		GEL_CORE_INFO("Creating window {0} ({1},{2})", props.Title, props.Width, props.Height);
		
		m_Device = MTLCreateSystemDefaultDevice();
		
		NSRect frame = NSMakeRect(0, 0, props.Width, props.Height);
		NSUInteger styleMask =
		NSWindowStyleMaskTitled |
		NSWindowStyleMaskTitled |
		NSWindowStyleMaskClosable |
		NSWindowStyleMaskResizable;
		
		m_Window=[[NSWindow alloc]initWithContentRect:frame
											styleMask:styleMask
											  backing:NSBackingStoreBuffered
												defer:NO];
		
		[m_Window setTitle:[NSString stringWithUTF8String:props.Title.c_str()]];
		[m_Window setAcceptsMouseMovedEvents:YES];
		[m_Window setRestorable:NO];
		
		GELWindowDelegate* windowDelegate = [[GELWindowDelegate alloc]initWithWindow:this];
		[m_Window setDelegate:windowDelegate];
		
		m_View=[[GELContentView alloc]initWithWindow:this];
		[m_Window setContentView:m_View];
		[m_Window makeFirstResponder:m_View];
		
		[m_Window center];
		[m_Window makeKeyAndOrderFront:nil];
	}
		
		
	void MacOSWindow::Shutdown()
	{
		[m_Window setDelegate:nil];
		[m_Window close];
		m_Window=nil;
		m_View =nil;
		m_MetalLayer=nil;
		m_Device=nil;
	}
	
	void MacOSWindow::OnUpdate()
	{
		@autoreleasepool {
			NSEvent* event;
			while((event=[NSApp nextEventMatchingMask:NSEventMaskAny
											untilDate:[NSDate distantPast]
											   inMode:NSDefaultRunLoopMode
											  dequeue:YES]))
			{
				[NSApp sendEvent:event];
			}
		}
	}
	
	void MacOSWindow::SetVSync(bool enabled)
	{
		m_Data.VSync = enabled;
	}
	
	bool MacOSWindow::IsVSync() const
	{
		return m_Data.VSync;
	}
}
