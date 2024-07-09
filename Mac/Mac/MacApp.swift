//
//  MacApp.swift
//  Mac
//
//  Created by FunWidget on 2024/6/6.
//

import SwiftUI
import Combine
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
    private var cancellable: AnyCancellable?
    private var cancellableTimer: AnyCancellable?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        ///设置不启动主窗口
        NSApplication.shared.windows.forEach { $0.close() }
        
        let contentView = HomeView()
        
        TimerOB.shared.refreshTimer()
        TimerOB.shared.startWorkTimer()
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            
            button.action = #selector(togglePopover(_:))
            
            cancellableTimer = NotificationCenter.default.publisher(for: .displayTimer)
                .sink { [weak self] _ in
                    if TimerOB.shared.showBarTimer{
                        self?.start()
                    }else{
                        self?.cancel()
                    }
                }
            
            if TimerOB.shared.showBarTimer{
                start()
            }else{
                cancel()
            }
            
        }
    }
    
    func start() {
        if let button = self.statusBarItem.button {
            
            let configuration = NSImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: nil)?.withSymbolConfiguration(configuration)
            
            button.font = NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular) // 调整文字大小
            cancellable = TimerOB.shared.$workTimeRemaining
                .sink { newValue in
                    button.title = newValue.formatTime()
                }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
        
        if let button = self.statusBarItem.button {
            
            let configuration = NSImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: nil)?.withSymbolConfiguration(configuration)
            button.title = ""
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
    static let displayTimer = Notification.Name("displayTimer")
}
