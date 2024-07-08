//
//  PreviewsView.swift
//  Mac
//
//  Created by FunWidget on 2024/7/8.
//

import SwiftUI

struct PreviewsView: View {
    @Binding var isPresented: Bool
    let prompt: String?
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            Text("00:00")
                .font(.system(size: 50, weight: .bold))
 
            Text(prompt ?? "Rest Your Eyes")
                .font(.system(size: 70, weight: .medium))
            
            Button("Dismiss") {
                isPresented = false
            }
            .buttonStyle(BorderedButtonStyle())

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
    PreviewsView(isPresented: .constant(true), prompt: "Preview")
}
