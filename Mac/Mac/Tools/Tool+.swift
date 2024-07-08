//
//  String+.swift
//  Mac
//
//  Created by FunWidget on 2024/7/4.
//

import SwiftUI
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension Int {
    func formatTime() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
