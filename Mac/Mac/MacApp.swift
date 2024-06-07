//
//  MacApp.swift
//  Mac
//
//  Created by FunWidget on 2024/6/6.
//

import SwiftUI

@main
struct MacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
 
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar) 
    }
}

private final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    
    @ObservedObject var controlModel = ControlModel()
 
    func applicationDidFinishLaunching(_ notification: Notification) {
 
        let contentView = HomeView().environmentObject(controlModel)
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
 
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            statusBarItem.button?.title = "⏳"
            button.action = #selector(togglePopover(_:))
        }
        
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
 
}
