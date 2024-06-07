//
//  ContentView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/6.
//

import SwiftUI

struct ContentView: View {
 
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .frame(width: 800, height: 600)
 
    }
}

#Preview {
    ContentView()
}
