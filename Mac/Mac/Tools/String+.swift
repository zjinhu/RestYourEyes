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
