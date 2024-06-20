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
    var body: some View {
        List {
            Section {
                
                Toggle("Show welcome message", isOn: $shouldStartAtLogin)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
            } header: {
                Text("qidong")
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
