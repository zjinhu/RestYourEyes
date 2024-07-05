//
//  AboutView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/20.
//

import SwiftUI
struct AboutView: View {
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: "gear")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
            
            Text(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "")
            
            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    AboutView()
}
