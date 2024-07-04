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
 
    @Published var timeRemaining = 0 // 20分钟倒计时，以秒为单位
    @Published var timeAll = 0
    @Published var timeing = false
    
    private var workItem: DispatchWorkItem?
    private var timer: Timer?
    
    func startTimer() {
        stopTimer() // 先停止已有的计时器
        refreshTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.timeRemaining -= 1
                }
                self.timeing = true
            } else {
                // 计时器完成，重新开始
                self.timeRemaining = self.timeAll
                self.showFullScreen.toggle()
                self.resumeTimerAfterPauseTime()
            }
        }
    }
    
    // 停止计时器的方法
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = timeAll
        timeing = false
    }
    
    func resumeTimerAfterPauseTime() {
        
        workItem = DispatchWorkItem {
            self.showFullScreen.toggle()
            self.startTimer()
        }
        if let workItem{
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(restTime), execute: workItem)
        }
        
    }
    
    func refreshTimer(){
        timeAll = workTime * 60
        timeRemaining = timeAll
    }
}
