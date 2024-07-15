//
//  ScreenController.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI
class ScreenController: NSWindowController {
    convenience init(rootView: AnyView, screen: NSScreen?) {
        let screenSize = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        let window = NSWindow(
            contentRect: screenSize,
            styleMask: [.fullScreen, .fullSizeContentView, .titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        window.level = .screenSaver
        window.isMovable = false
 
        window.titlebarAppearsTransparent = true
        window.backgroundColor = .clear
        window.titleVisibility = .hidden
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.backgroundColor = NSColor.clear.cgColor 
        
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true

        window.isMovableByWindowBackground = true
        
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenPrimary]
        
        self.init(window: window)

        window.contentView = NSHostingView(rootView: rootView)
//        self.contentViewController = NSHostingController(rootView: rootView)
        let clsname = NSClassFromString("NSTitlebarContainerView") as? NSObject.Type
        window.contentView?.superview?.subviews.forEach({ view in
            if let clsname, view.isKind(of: clsname){
                view.removeFromSuperview()
            }
        })
    }

    func showFullScreen() {
        guard let window = self.window else { return }
        window.makeKeyAndOrderFront(nil)
    }

    func closeFullScreen() {
        self.window?.orderOut(nil)
    }

}

