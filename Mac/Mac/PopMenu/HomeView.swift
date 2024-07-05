//
//  HomeView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var timerOB = TimerOB.shared
    
    @State var screenController: ScreenController?
    @State var showContent = false
 
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
            
            Spacer()
            
            ZStack{
                ProgressBarView(progress: $timerOB.workTimeRemaining, goal: $timerOB.workTimeAll)
                
                VStack{
                    Text("\(formatTime(seconds: timerOB.workTimeRemaining))")
                        .font(.largeTitle)
                        .padding()
                    
                    if timerOB.workTimeing{
                        Button(action: timerOB.stopWorkTimer) {
                            Image(systemName: "stop.fill")
                                .padding(10)
                        }
                    }else{
                        Button(action: timerOB.startWorkTimer) {
                            Image(systemName: "play.fill")
                                .padding(10)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button("Take a rest") {
                timerOB.showFullScreen.toggle()
                timerOB.startRestTimer()
            }
            .padding()
            
        }
        .frame(width: 400, height: 500)
        .onChange(of: timerOB.showFullScreen) { showFullScreen in
            if showFullScreen {
                let screenView = ScreenView(isPresented: $timerOB.showFullScreen)
                let controller = ScreenController(rootView: AnyView(screenView))
                controller.showFullScreen()
                screenController = controller
            } else {
                timerOB.startWorkTimer()
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

