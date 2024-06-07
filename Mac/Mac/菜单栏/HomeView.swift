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
    
    var body: some View {
        VStack{
            Text("Time Remaining: \(formatTime(seconds: controlModel.timeRemaining))")
                .font(.largeTitle)
                .padding()
            
            Button("FullScreen") {
                controlModel.showFullScreen.toggle()
            }
            
            Button("Content") {
                controlModel.showContent.toggle()
            }
            
            HStack {
                Button(action: controlModel.startTimer) {
                    Text("Start Timer")
                }
                .padding()
                
                Button(action: controlModel.stopTimer) {
                    Text("Stop Timer")
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: controlModel.showFullScreen) {
            if controlModel.showFullScreen {
                let screenView = ScreenView(isPresented: $controlModel.showFullScreen)
                let controller = ScreenController(rootView: AnyView(screenView))
                controller.showFullScreen()
                screenController = controller
            } else {
                screenController?.closeFullScreen()
            }
        }
        .onChange(of: controlModel.showContent) {
            if controlModel.showContent {
                let view = ContentView()
                let controller = ContentController(rootView: AnyView(view), isPresented: $controlModel.showContent)
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
 
