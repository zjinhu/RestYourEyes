//
//  HomeView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var controlModel: ControlModel
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
                self.timeRemaining = self.controlModel.countTime
                self.showFullScreen.toggle()
            }
        }
    }

    // 停止计时器的方法
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = controlModel.countTime
    }
    
    
    var body: some View {
        VStack{
            Text("Time Remaining: \(formatTime(seconds: timeRemaining))")
                .font(.largeTitle)
                .padding()
            
            Button("FullScreen") {
                showFullScreen.toggle()
            }
            
            Button("Content") {
                showContent.toggle()
            }
            
            HStack {
                Button(action: startTimer) {
                    Text("Start Timer")
                }
                .padding()
                
                Button(action: stopTimer) {
                    Text("Stop Timer")
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: showFullScreen) {
            if showFullScreen {
                let screenView = ScreenView(isPresented: $showFullScreen)
                let controller = ScreenController(rootView: AnyView(screenView))
                controller.showFullScreen()
                screenController = controller
            } else {
                screenController?.closeFullScreen()
            }
        }
        .onChange(of: showContent) {
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
 
