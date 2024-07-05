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
 
                Button {
                    showContent.toggle()
                } label: {
                    Image(systemName: "gear.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(NoBackgroundButtonStyle())
                
                Spacer()
                
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(systemName: "power.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(NoBackgroundButtonStyle())

            }
            
            Spacer()
            
            ZStack{
                ProgressBarView(progress: $timerOB.workTimeRemaining, goal: $timerOB.workTimeAll)
                    .frame(width: 180)
                
                if timerOB.workTimeing{
                    Button(action: timerOB.stopWorkTimer) {
                        Image(systemName: "pause")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .buttonStyle(NoBackgroundButtonStyle())
                }else{
                    Button(action: timerOB.startWorkTimer) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .buttonStyle(NoBackgroundButtonStyle())
                }
                
            }
            
            Spacer()
            
            VStack{
                Text("\(formatTime(seconds: timerOB.workTimeRemaining))")
                    .font(.largeTitle)

                if timerOB.workTimeing{
                    Text("WorkTiping \(timerOB.restTime)")
                }else{
                    Text("StopWork")
                }
            }
            
            Spacer()
            
            Button("Take a rest") {
                timerOB.showFullScreen.toggle()
                timerOB.startRestTimer()
            }
            .buttonStyle(BorderedButtonStyle())
            .padding(.bottom, 16)
            
        }
        .frame(width: 280, height: 450)
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

struct NoBackgroundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .contentShape(Rectangle())
            .background(Color.clear)
            .foregroundColor(.primary)
    }
}

struct BorderedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.clear)
            .foregroundColor(.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.6 : 1.0) // 按下时改变透明度
    }
}
