//
//  ProgressBarView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/21.
//

import SwiftUI

struct ProgressBarView: View {

    @Binding var progress: Int
    @Binding var goal: Int

    var gradient = Gradient(colors: [.red, .orange, .yellow, .green])

    var trackColor = Color.white.opacity(0.2)

    var trackWidth = 15.0

    var isAnimated:Bool = true

    public init(progress: Binding<Int>,
                goal: Binding<Int>,
                gradient: Gradient = Gradient(colors: [.green, .yellow, .orange, .red]),
                trackColor: Color = Color.gray.opacity(0.2),
                trackWidth: Double = 15.0,
                isAnimated: Bool = true) {
        _progress = progress
        _goal = goal
        self.gradient = gradient
        self.trackColor = trackColor
        self.trackWidth = trackWidth
        self.isAnimated = isAnimated
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: CGFloat(trackWidth))
                .foregroundColor(trackColor)
            
            if isAnimated {
                Circle()
                    .trim(from: 0.0, to: CGFloat(goal-progress) / CGFloat(goal))
                    .stroke(
                        AngularGradient(gradient: gradient, center: .center, startAngle: .zero, endAngle: .degrees(360)),
                        lineWidth: CGFloat(trackWidth)
                    )
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: UUID())
            } else {
                Circle()
                    .trim(from: 0.0, to: CGFloat(goal-progress) / CGFloat(goal))
                    .stroke(
                        AngularGradient(gradient: gradient, center: .center, startAngle: .zero, endAngle: .degrees(360)),
                        lineWidth: CGFloat(trackWidth)
                    )
                    .rotationEffect(Angle(degrees: 270.0))
            }
        }
    }
}

#Preview {
    ProgressBarView(
        progress: .constant(10),
        goal: .constant(100)
    )
    .frame(width: 180)
    .preferredColorScheme(.light)
}
