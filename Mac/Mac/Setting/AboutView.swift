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
            Image("icon")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
            
            Text(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "")
                .font(.title3)
            
            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")
                .font(.footnote)
        }
        .frame(width: 400, height: 400)
    }
}

#Preview {
    AboutView()
        .preferredColorScheme(.light)
}
