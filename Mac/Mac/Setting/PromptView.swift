//
//  PromptView.swift
//  Mac
//
//  Created by FunWidget on 2024/7/5.
//

import SwiftUI
import CoreData
import SwiftUIIntrospect
struct PromptView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var isAddPrompt: Bool = false
    @State var isUpDatePrompt: Bool = false
    @State var isDeletePrompt: Bool = false
    @State var isPreviewPrompt: Bool = false
    @State var windowControllers: [ScreenController] = []
    
    @State var selectItem: Item?
    @State var inputPrompt: String = ""
    
    var body: some View {
        
        Group {
            if items.isEmpty{
                VStack(alignment: .leading){
                    Text("1. Please click below + to add a prompt")
                    Text("2. The prompts switch will read more than one randomly")
                    Text("3. Right-click on a prompt to edit or delete it")
                }
                
            }else{
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
                                    isPreviewPrompt.toggle()
                                } label: {
                                    Text("Preview")
                                }
                                
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
            }
        }
        .frame(width: 400, height: 400)
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

                TextEditor(text: $inputPrompt)
                    .frame(maxHeight: .infinity)
                    .introspect(.textEditor, on: .macOS(.v13, .v14, .v15)) { textView in
                        guard let scrollView = textView.enclosingScrollView else { return }
                        scrollView.autohidesScrollers = true
                    }
                
                HStack{
                    Button{
                        isAddPrompt.toggle()
                        inputPrompt = ""
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    
                    Button{
                        if !inputPrompt.isEmpty{
                            addItem(inputPrompt)
                            isAddPrompt.toggle()
                        }
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .frame(width: 200, height: 120)
        }
        .sheet(isPresented: $isUpDatePrompt){
            VStack{
                TextEditor(text: $inputPrompt)
                    .frame(maxHeight: .infinity)
                    .introspect(.textEditor, on: .macOS(.v13, .v14, .v15)) { textView in
                        guard let scrollView = textView.enclosingScrollView else { return }
                        scrollView.autohidesScrollers = true
                    }
                
                HStack{
                    Button{
                        isUpDatePrompt.toggle()
                        inputPrompt = ""
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    
                    Button{
                        if let selectItem, !inputPrompt.isEmpty{
                            updateItem(selectItem, text: inputPrompt)
                            isUpDatePrompt.toggle()
                        }
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .frame(width: 200, height: 120)
            
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
        .onChange(of: isPreviewPrompt) { showFullScreen in
            if showFullScreen {
                for screen in NSScreen.screens{
                    let screenView = PreviewsView(isPresented: $isPreviewPrompt, prompt: selectItem?.text)
                    let controller = ScreenController(rootView: AnyView(screenView), screen: screen)
                    controller.showFullScreen()
                    windowControllers.append(controller)
                }
            } else {
                for window in windowControllers{
                    window.closeFullScreen()
                }
                windowControllers.removeAll()
            }
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
