//
//  CharRainCell.swift
//  Mac
//
//  Created by FunWidget on 2024/7/8.
//

import SwiftUI

struct CharRainCell: View {
    var body: some View {
        ZStack{
            TimelineView(.periodic(from: .now, by: 0.15)) { timeline in
                CharRainView(date: timeline.date, columnSize: 8)
                    .ignoresSafeArea()
            }
            
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
        }
        .frame(width: 200, height: 150)
    }
}

#Preview {
    CharRainCell()
}
