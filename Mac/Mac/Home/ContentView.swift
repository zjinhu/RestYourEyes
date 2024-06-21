//
//  ContentView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/6.
//

import SwiftUI

struct ContentView: View {
    @State private var selectIndex = 0
    
    let tabItems = [
        TabModel(title: "Settings", iconName: "gear"),
        TabModel(title: "Theme", iconName: "paintpalette"),
        TabModel(title: "About", iconName: "exclamationmark.circle")
    ]
    
    let tabViews: [AnyView] = [
        AnyView(SettingView()),
        AnyView(ThemeView()),
        AnyView(AboutView())
    ]
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                ForEach(tabItems) { index, item in

                    VStack(spacing: 5){
                        Image(systemName: item.iconName)
                        Text(item.title)
                    }
                    .foregroundColor(selectIndex == index ? Color.black : Color.white)
                    .padding(20)
                    .background( selectIndex == index ? Color.white : Color.white.opacity(0.0001))
                    .cornerRadius(8)
                    .onTapGesture {
                        selectIndex = index
                    }
                }
                
                Spacer()
            }
            .padding(5)
            
            Divider()
            
            tabViews[selectIndex]
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 400, maxWidth: 800, minHeight: 300, maxHeight: 600)
        
    }
}

#Preview {
    ContentView()
}

struct TabModel: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}
