//
//  DefaultCell.swift
//  Mac
//
//  Created by FunWidget on 2024/7/8.
//

import SwiftUI

struct DefaultCell: View {
    var body: some View {
        VStack {
            Text("00:00")
                .font(.system(size: 12, weight: .bold))
                .padding(.top, 30)
 
            Text("Rest Your Eyes")
                .font(.system(size: 16, weight: .medium))
            
            Button("Dismiss") {

            }
            .buttonStyle(BorderedButtonStyle())
            .scaleEffect(0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .frame(width: 200, height: 150)

    }
}

#Preview {
    DefaultCell()
}
