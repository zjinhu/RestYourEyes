//
//  HomeView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("workTime") private var workTime: Int = 20
    @AppStorage("restTime") private var restTime: Int = 20
    
    @State var screenController: ScreenController?
    @State var contentController: ContentController?

    @State var showFullScreen = false
    @State var showContent = false
    
    @State var timeRemaining = 0 // 20分钟倒计时，以秒为单位
    @State var timer: Timer?
    
    func startTimer() {
        stopTimer() // 先停止已有的计时器

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                // 计时器完成，重新开始
                self.timeRemaining = self.workTime * 60
                self.showFullScreen.toggle()
                self.resumeTimerAfterPauseTime()
            }
        }
    }

    // 停止计时器的方法
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = workTime * 60
    }
    
    func resumeTimerAfterPauseTime() {
        let delay = DispatchTime.now() + TimeInterval(restTime)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.showFullScreen.toggle()
            self.startTimer()
        }
    }
    
    
    @State private var sort: Int = 0
    var body: some View {
        VStack{
            HStack{
                Button("设置") {
                    showContent.toggle()
                }
                
                Spacer()
                
                Button("退出") {
                    NSApp.terminate(nil)
                }
            }
            .padding()
            
            Text("Time Remaining: \(formatTime(seconds: timeRemaining))")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: startTimer) {
                Text("Start Timer")
            }
            
            HStack {

                Button("休息一下") {
                    showFullScreen.toggle()
                }
                
                
                Button(action: stopTimer) {
                    Text("重置计划")
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: showFullScreen) { showFullScreen in
            if showFullScreen {
                let screenView = ScreenView(isPresented: $showFullScreen)
                let controller = ScreenController(rootView: AnyView(screenView))
                controller.showFullScreen()
                screenController = controller
            } else {
                screenController?.closeFullScreen()
            }
        }
        .onChange(of: showContent) { showFullScreen in
            if showContent {
                let view = ContentView()
                let controller = ContentController(rootView: AnyView(view), isPresented: $showContent)
                controller.showView()
                contentController = controller
            } else {
                contentController?.closeView()
            }
        }

    }

    // 格式化时间的方法
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}

#Preview {
    HomeView()
}
 
