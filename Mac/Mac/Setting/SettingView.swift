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
    
    @StateObject var timerOB = TimerOB.shared
    
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
 
                LabeledStepper(value: $timerOB.workTime, in: 1...60) {
                    Text("WorkTime \(timerOB.workTime)")
                }
                
                LabeledStepper(value: $timerOB.restTime, in: 1...60) {
                    Text("RestTime \(timerOB.restTime)")
                }
                
            } header: {
                Text("Restplan")
            }
            
            Section {
                
                Toggle("Allow Skip", isOn: $timerOB.canJump)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
            } header: {
                Text("Display Rules")
            }

        }
        .frame(width: 400, height: 300)
        .onChange(of: launchAtLogin) { newValue in
            setLaunchAtStartup(newValue)
        }
        .onChange(of: timerOB.workTime) { newValue in
            timerOB.refreshTimer()
        }
        .onChange(of: timerOB.restTime) { newValue in
            timerOB.refreshTimer()
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
