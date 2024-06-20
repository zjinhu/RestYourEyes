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
    @AppStorage("canJump") private var canJump: Bool = true
    
    var body: some View {
        VStack {
            Text("This is a full screen cover")
            if canJump{
                Button("Dismiss") {
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
}

#Preview {
    ScreenView(isPresented: .constant(true))
}
