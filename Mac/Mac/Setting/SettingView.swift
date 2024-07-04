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
 
    @State var launchAtLogin: Bool
    
    @AppStorage("workTime") private var workTime: Int = 20
    @AppStorage("restTime") private var restTime: Int = 20
    @AppStorage("canJump") private var canJump: Bool = true
    
    init() {
            self.launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    
    var body: some View {
        List {
            Section {
                
                Toggle("LaunchAuto", isOn: $launchAtLogin)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
            } header: {
                Text("LaunchHeader")
            }
            
            Section {
                
                Stepper(value: $workTime, in: 1...60, step: 1) {
                    Text("WorkTime \(workTime)")
                }
                
                Stepper(value: $restTime, in: 1...60, step: 1) {
                    Text("RestTime \(restTime)")
                }
                
            } header: {
                Text("Restplan")
            }
            
            Section {
                
                Toggle("Allow Skip", isOn: $canJump)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
            } header: {
                Text("Display Rules")
            }

        }
        .frame(width: 800, height: 600)
        .onChange(of: launchAtLogin) { newValue in
            setLaunchAtStartup(newValue)
        }

    }
    
    func setLaunchAtStartup(_ shouldStart: Bool) {
        do {
            if shouldStart {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            Swift.print(error.localizedDescription)
        }
        if shouldStart != (SMAppService.mainApp.status == .enabled) {
            launchAtLogin = shouldStart
        }
    }
}

#Preview {
    SettingView()
}
