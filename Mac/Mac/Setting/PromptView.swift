//
//  PromptView.swift
//  Mac
//
//  Created by FunWidget on 2024/7/5.
//

import SwiftUI
import CoreData

struct PromptView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var isAddPrompt: Bool = false
    @State var isUpDatePrompt: Bool = false
    @State var isDeletePrompt: Bool = false
    @State var selectItem: Item?
    @State var inputPrompt: String = ""
    
    var body: some View {
        
        List {
            ForEach(items) { item in
 
                    HStack{
                        Text(item.text ?? "")
                        
                        Spacer()
                        
                        Toggle("", isOn:
                                Binding(
                                    get: { item.open },
                                    set: { newValue in
                                        item.open = newValue
                                        try? viewContext.save()
                                    }
                                )
                        )
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                        .labelsHidden()
                    }
                    .contextMenu{
                        Button{
                            selectItem = item
                            isUpDatePrompt.toggle()
                        } label: {
                            Text("Edit")
                        }
                        
                        Button{
                            selectItem = item
                            isDeletePrompt.toggle()
                        } label: {
                            Text("Delete")
                        }
                    }

            }
        }
        .frame(width: 400, height: 600)
        .overlay(alignment: .bottomTrailing) {
            Button{
                isAddPrompt.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .shadow(radius: 5, y: 5)
                    .padding()
            }
            .buttonStyle(NoBackgroundButtonStyle())
        }
        .sheet(isPresented: $isAddPrompt){
            VStack{
                TextField("Please input", text: $inputPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                    Button{
                        isAddPrompt.toggle()
                        inputPrompt = ""
                    } label: {
                        Text("Cancel")
                    }
                    
                    Button{
                        if !inputPrompt.isEmpty{
                            addItem(inputPrompt)
                            isAddPrompt.toggle()
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
        .sheet(isPresented: $isUpDatePrompt){
            VStack{
                TextField("Please input", text: $inputPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                    Button{
                        isUpDatePrompt.toggle()
                        inputPrompt = ""
                    } label: {
                        Text("Cancel")
                    }
                    
                    Button{
                        if let selectItem, !inputPrompt.isEmpty{
                            updateItem(selectItem, text: inputPrompt)
                            isUpDatePrompt.toggle()
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
            
        }
        .alert(isPresented: $isDeletePrompt) {
            Alert(
                title: Text("Delete"),
                message: Text("Are you sure to delete \(selectItem?.text ?? "")?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let item = selectItem {
                        deleteItem(item)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func addItem(_ text: String) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.text = text
            do {
                try viewContext.save()
                inputPrompt = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItem(_ item: Item) {
        withAnimation {
            viewContext.delete(item)
            do {
                try viewContext.save()
                selectItem = nil
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func updateItem(_ item: Item, text: String) {
        withAnimation {
 
            item.text = text
 
            do {
                try viewContext.save()
                selectItem = nil
                inputPrompt = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
 
#Preview {
    PromptView()
        .preferredColorScheme(.light)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
