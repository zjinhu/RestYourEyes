//
//  ThemeView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/20.
//

import SwiftUI

enum ThemeStyle{
    case charRain
    case color
}

struct ThemeView: View {
    @State private var selected: ThemeStyle = .color
    
    var body: some View {
        List{
            HStack{
                DefaultCell()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selected = .color
            }
            
            HStack{
                CharRainCell()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selected = .charRain
            }
        }
        .frame(width: 440, height: 300)
    }
}

#Preview {
    ThemeView()
}
