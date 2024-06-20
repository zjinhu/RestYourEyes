//
//  SettingView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/20.
//

import SwiftUI
import ServiceManagement
import Combine
struct SettingView: View {
    @State private var shouldStartAtLogin: Bool = false
    
    @AppStorage("workTime") private var workTime: Int = 20
    @AppStorage("restTime") private var restTime: Int = 20
    @AppStorage("canJump") private var canJump: Bool = true
    
    var body: some View {
        List {
            Section {
                
                Toggle("Show welcome message", isOn: $shouldStartAtLogin)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
            } header: {
                Text("登录项")
            }
            
            Section {
                
                Stepper(value: $workTime, in: 1...60, step: 1) {
                    Text("每次工作时长 \(workTime)")
                }
                
                Stepper(value: $restTime, in: 1...60, step: 1) {
                    Text("每次休息时长 \(restTime)")
                }
                
            } header: {
                Text("休息规则")
            }
            
            Section {
                
                Toggle("允许跳过", isOn: $canJump)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
            } header: {
                Text("显示规则")
            }

        }
        .onChange(of: shouldStartAtLogin) { newValue in
            setLaunchAtStartup(newValue)
        }

    }
    
    func setLaunchAtStartup(_ shouldStart: Bool) {
        let appBundleIdentifier = "com.yourcompany.yourapp.LauncherApplication"
        SMLoginItemSetEnabled(appBundleIdentifier as CFString, shouldStart)
    }
}

#Preview {
    SettingView()
}
