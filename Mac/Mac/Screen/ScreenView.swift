//
//  ScreenView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI

struct ScreenView: View {
    @Binding var isPresented: Bool
    @State private var isVisible = false
    @StateObject var timerOB = TimerOB.shared
    
    var body: some View {
        VStack {
            Text("\(formatTime(seconds: timerOB.restTimeRemaining))")
                .font(.largeTitle)
                .padding()
            
            Text("This is a full screen cover")
            
            if timerOB.canJump{
                Button("Dismiss") {
                    timerOB.startWorkTimer()
                    isPresented = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(isVisible ? 1 : 0) 
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isVisible.toggle()
            }
        }
    }
    
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ScreenView(isPresented: .constant(true))
}
