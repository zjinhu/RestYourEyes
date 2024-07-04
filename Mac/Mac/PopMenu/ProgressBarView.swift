//
//  ProgressBarView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/21.
//

import SwiftUI

struct ProgressBarView: View {
  
  @Binding var progress: Int // Current progress of timer
  @Binding var goal: Int // Total goal time
  
  var body: some View {
    
    ZStack {
      // Default circle
      Circle()
        .stroke(
          style: StrokeStyle(
            lineWidth: 20,
            lineCap: .butt,
            dash: [2, 6])
        )
        .fill(Color.gray)
        .rotationEffect(Angle(degrees: -90))
        .frame(
          width: 250,
          height: 250
        )
      
      // overlap circle
      Circle()
        .trim(
          from: 0,
          to: CGFloat(progress) / CGFloat(goal)
        )
        .stroke(
          style: StrokeStyle(
            lineWidth: 20,
            lineCap: .butt,
            dash: [2, 6])
        )
        .fill(
          Color(
            red: 236/255, green: 230/255, blue: 0/255
          )
        )
        .animation(
          .spring(),
          value: progress
        )
        .rotationEffect(Angle(degrees: -90))
        .frame(
          width: 250,
          height: 250
        )
    }
  }
}


#Preview {
    ProgressBarView(
        progress: .constant(10),
        goal: .constant(100)
    )
}
