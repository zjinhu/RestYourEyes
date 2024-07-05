//
//  TimerOB.swift
//  Mac
//
//  Created by FunWidget on 2024/7/4.
//

import SwiftUI
class TimerOB: ObservableObject{
    private init() { }
    static let shared = TimerOB()
    
    @AppStorage("workTime") var workTime: Int = 20
    @AppStorage("restTime") var restTime: Int = 20
    @AppStorage("canJump") var canJump: Bool = true
    
    @Published var showFullScreen = false
 
    @Published var workTimeRemaining = 0 // 20分钟倒计时，以秒为单位
    @Published var workTimeAll = 0
    @Published var workTimeing = false
 
    @Published var restTimeRemaining = 0 // 20分钟倒计时，以秒为单位
    @Published var restTimeAll = 0
    
    private var workTimer: Timer?
    private var restTimer: Timer?
    
    func startWorkTimer() {
        stopRestTimer()
        stopWorkTimer()
        refreshWorkTimer()
        workTimeing = true
        workTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.workTimeRemaining > 0 {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.workTimeRemaining -= 1
                }
            } else {
                self.showFullScreen.toggle()
                self.startRestTimer()
            }
        }
    }

    func stopWorkTimer() {
        workTimeing = false
        workTimer?.invalidate()
        workTimer = nil
    }
    
    func startRestTimer() {
        stopWorkTimer()
        stopRestTimer()
        refreshRestTimer()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.restTimeRemaining > 0 {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.restTimeRemaining -= 1
                }
            } else {
                self.showFullScreen.toggle()
                self.startWorkTimer()
            }
        }
    }
    
    func stopRestTimer(){
        restTimer?.invalidate()
        restTimer = nil
    }
    
    private func refreshWorkTimer(){
        workTimeAll = workTime * 60
        workTimeRemaining = workTimeAll
    }
    
    private func refreshRestTimer(){
        restTimeAll = restTime
        restTimeRemaining = restTimeAll
    }
    
    func refreshTimer(){
//        stopWorkTimer()
//        stopRestTimer()
        refreshWorkTimer()
        refreshRestTimer()
    }
}
