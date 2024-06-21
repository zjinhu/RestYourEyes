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
//                .onAppear{
//                    if let window = NSApplication.shared.windows.first {
//                        DispatchQueue.main.asyncAfter(deadline: .now()) {
//                            // 延时关闭窗口
//                            window.close()
//                        }
//                    }
//                }
        }
//        .windowStyle(.hiddenTitleBar)
    }
}

private final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
 
    func applicationDidFinishLaunching(_ notification: Notification) {
        ///设置不启动主窗口
        NSApplication.shared.windows.forEach { $0.close() }
        
        let contentView = HomeView()
        
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
