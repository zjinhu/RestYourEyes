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
//    @State var contentController: ContentController?
    
    @State var showFullScreen = false
    @State var showContent = false
    
    @State var timeRemaining = 0 // 20分钟倒计时，以秒为单位
    @State var timer: Timer?
    
    @State var timeAll = 0
    @State var timeing = false
    
    @State private var workItem: DispatchWorkItem?
    
    func startTimer() {
        stopTimer() // 先停止已有的计时器
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.timeRemaining -= 1
                }
                timeing = true
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
    
    var body: some View {
        VStack{
            HStack{
                Button("Settings") {
                    showContent.toggle()
                }
                
                Spacer()
                
                Button("Quit") {
                    NSApp.terminate(nil)
                }
            }
            .padding()
            
            ZStack{
                ProgressBarView(progress: $timeRemaining, goal: $timeAll)
                
                VStack{
                    Text("\(formatTime(seconds: timeRemaining))")
                        .font(.largeTitle)
                        .padding()
                    
                    if timeing{
                        Button(action: stopTimer) {
                            Image(systemName: "stop.fill")
                                .padding(10)
                        }
                    }else{
                        Button(action: startTimer) {
                            Image(systemName: "play.fill")
                                .padding(10)
                        }
                    }
                }
            }
            
            Button("Take a rest") {
                showFullScreen.toggle()
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            timeAll = workTime * 60
            timeRemaining = timeAll
        }
        .onChange(of: showFullScreen) { showFullScreen in
            if showFullScreen {
                let screenView = ScreenView(isPresented: $showFullScreen)
                let controller = ScreenController(rootView: AnyView(screenView))
                controller.showFullScreen()
                screenController = controller
            } else {
                workItem?.cancel()
                workItem = nil
                startTimer()
                screenController?.closeFullScreen()
            }
        }
        .onChange(of: showContent) { showFullScreen in
            ///使用第三方设置页面
            settingsWindowController.show()
            ///我自己实现的SwiftUI设置页面
//            if showContent {
//                let view = ContentView()
//                let controller = ContentController(rootView: AnyView(view), isPresented: $showContent)
//                controller.showView()
//                contentController = controller
//            } else {
//                contentController?.closeView()
//            }
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

