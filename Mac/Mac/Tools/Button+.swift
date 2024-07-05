//
//  Button+.swift
//  Mac
//
//  Created by FunWidget on 2024/7/5.
//

import SwiftUI

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
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}
