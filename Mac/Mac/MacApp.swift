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
            ///设置不启动主窗口可以设置成EmptyView()
            EmptyView()
        }
    }
}

private final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var eventMonitor: Any?
    
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
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown], handler: { (event) in
            if let popover = self.popover, popover.isShown {
                popover.performClose(nil)
            }
        })
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // 移除全局事件监控器
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
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

extension Notification.Name {
    static let changeTimer = Notification.Name("changeTimer")
    static let launchStart = Notification.Name("launchStart")
}
