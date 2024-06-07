//
//  ControlModel.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import Foundation


class ControlModel: ObservableObject{
    
    @Published var countTime = 5
    @Published var restTime = 5

    @Published var showFullScreen = false
    
    @Published var showContent = false
    
    @Published var timeRemaining = countTime // 20分钟倒计时，以秒为单位
    @Published var timer: Timer?
    
    
    func startTimer() {
        stopTimer() // 先停止已有的计时器

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                // 计时器完成，重新开始
                self.timeRemaining = countTime
                self.showFullScreen.toggle()
            }
        }
    }

    // 停止计时器的方法
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = countTime
    }


}
