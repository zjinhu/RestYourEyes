//
//  TimePlanView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/20.
//

import SwiftUI

struct TimePlanView: View {

    @AppStorage("workTime") private var workTime: Int = 20
    @AppStorage("restTime") private var restTime: Int = 20
    
    var body: some View {
        List {
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
        }
    }
}

#Preview {
    TimePlanView()
}
