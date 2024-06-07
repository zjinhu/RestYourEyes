//
//  ContentController.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI

class ContentController: NSWindowController, NSWindowDelegate{

    var isPresented: Binding<Bool>?
    
    convenience init(rootView: AnyView, isPresented: Binding<Bool>) {
        let screenSize = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        let window = NSWindow(
            contentRect: screenSize,
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces]
        self.init(window: window)
        let hostingView = NSHostingView(rootView: rootView)
        window.contentView = hostingView
        window.center()
        window.delegate = self
        self.isPresented = isPresented
    }

    func showView() {
        guard let window = self.window else { return }
        window.makeKeyAndOrderFront(nil)
    }

    func closeView() {
        self.window?.orderOut(nil)
    }
    
    func windowWillClose(_ notification: Notification) {
        isPresented?.wrappedValue.toggle()
    }
}
