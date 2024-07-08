//
//  CharRainView.swift
//  Mac
//
//  Created by FunWidget on 2024/7/8.
//

import SwiftUI
import BrickKit
struct CharRainView: View {
    let date: Date
    let columnSize: CGFloat
    @State private var nextIdx: [Int] = []
    @State private var row: [SavedChar] = []
    @State private var rows: [[SavedChar]] = []
    
    var body: some View {
        Canvas { context, size in
            context
                .fill(.init(roundedRect: .init(origin: .zero, size: size), cornerRadius: 0), with: .color(.black))
            
            for row in rows {
                for char in row {
                    context.draw(char.textView, in: char.pos)
                    char.opacity -= 0.1
                }
            }
        }
        .onAppear() {
            let columnCount = Int(Screen.main.frame.size.width / columnSize)
            nextIdx = Array(repeating: 0, count: columnCount)
        }
        .onChange(of: date) { newValue in
            row = []
            for e in nextIdx.enumerated() {
                let pos = CGRect(x: columnSize * CGFloat(e.offset), y: columnSize *
                                 CGFloat(e.element), width: columnSize, height: columnSize)
                row.append(
                    SavedChar(text: getRandomChar(),
                              textSize: columnSize,
                              pos: pos,
                              color: .green,
                              opacity: 1)
                )
            }
            rows.append(row)
            rows = rows.filter({ row in
                return row[0].opacity > 0
            })
            nextIdx = nextIdx.map({x in
                let result = x + 1
                if x > Int(Screen.main.frame.size.height / columnSize) && Double.random(in: 0...1) > 0.8 {
                    return 0
                }
                return result
            })

        }
    }
    
    func getRandomChar() -> String {
        return String("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".randomElement() ?? "a")
    }
}

#Preview {
    TimelineView(.periodic(from: .now, by: 0.15)) { timeline in
        CharRainView(date: timeline.date, columnSize: 16)
            .ignoresSafeArea()
    }
}

class SavedChar {
    let text: String
    let pos: CGRect
    let color: Color
    var opacity: CGFloat = 1.0
    let textSize: CGFloat
    init(text: String,
         textSize: CGFloat,
         pos: CGRect,
         color: Color,
         opacity: CGFloat) {
        self.text = text
        self.textSize = textSize
        self.pos = pos
        self.color = color
        self.opacity = opacity
    }
    var textView: Text {
        Text(text)
            .font(.system(size: textSize))
            .foregroundColor(color.opacity(opacity))
    }
}
