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
 
                LabeledStepper(value: $workTime, in: 1...60) {
                    Text("WorkTime \(workTime)")
                }
                
                LabeledStepper(value: $restTime, in: 1...60) {
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
        .frame(width: 400, height: 400)
        .onChange(of: launchAtLogin) { newValue in
            setLaunchAtStartup(newValue)
        }
        .onChange(of: workTime) { newValue in
            NotificationCenter.default.post(name: .changeTimer, object: nil)
        }
        .onChange(of: restTime) { newValue in
            NotificationCenter.default.post(name: .changeTimer, object: nil)
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
