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
        TabModel(title: "设置", iconName: "gear"),
        TabModel(title: "主题", iconName: "paintpalette"),
        TabModel(title: "关于", iconName: "exclamationmark.circle")
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
//        .frame(minWidth: 400, minHeight: 500)
//        .frame(maxWidth: 600, maxHeight: 600)
        
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

extension ForEach {
    @_disfavoredOverload
    @inlinable
    public init<_Data: RandomAccessCollection>(
        _ data: _Data,
        @ViewBuilder content: @escaping (_Data.Index, _Data.Element) -> Content
    ) where Data == Array<(_Data.Index, _Data.Element)>, ID == _Data.Index, Content: View {
        let elements = Array(zip(data.indices, data))
        self.init(elements, id: \.0) { index, element in
            content(index, element)
        }
    }

    @inlinable
    public init<
        _Data: RandomAccessCollection
    >(
        _ data: _Data,
        id: KeyPath<_Data.Element, ID>,
        @ViewBuilder content: @escaping (_Data.Index, _Data.Element) -> Content
    ) where Data == Array<(_Data.Index, _Data.Element)>, Content: View {
        let elements = Array(zip(data.indices, data))
        let elementPath: KeyPath<(_Data.Index, _Data.Element), _Data.Element> = \.1
        self.init(elements, id: elementPath.appending(path: id)) { index, element in
            content(index, element)
        }
    }

    @inlinable
    public init<
        _Data: RandomAccessCollection
    >(
        _ data: _Data,
        @ViewBuilder content: @escaping (_Data.Index, _Data.Element) -> Content
    ) where Data == Array<(_Data.Index, _Data.Element)>, _Data.Element: Identifiable, ID == _Data.Element.ID, Content: View {
        let elements = Array(zip(data.indices, data))
        self.init(elements, id: \.1.id) { index, element in
            content(index, element)
        }
    }
}
