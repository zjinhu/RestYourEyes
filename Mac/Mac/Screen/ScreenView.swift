//
//  ScreenView.swift
//  Mac
//
//  Created by FunWidget on 2024/6/7.
//

import SwiftUI

struct ScreenView: View {
    @Binding var isPresented: Bool
    @State private var isVisible = false
    @StateObject var timerOB = TimerOB.shared
    
    
    @Environment(\.managedObjectContext) private var viewContext
 
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        predicate: \Item.open == true,
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var promptText = "Rest Your Eyes"
    
    var body: some View {
        VStack {
            Text(timerOB.restTimeRemaining.formatTime())
                .font(.system(size: 50, weight: .bold))
 
            Text(promptText)
                .font(.system(size: 70, weight: .medium))
            
            if timerOB.canJump{
                Button("Dismiss") {
                    timerOB.startWorkTimer()
                    isPresented = false
                }
                .buttonStyle(BorderedButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(isVisible ? 1 : 0) 
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isVisible.toggle()
                if let text = items.randomElement()?.text{
                    promptText = text
                }
            }
        }
    }
}

#Preview {
    ScreenView(isPresented: .constant(true))
}

func == <T>(lhs: KeyPath<some NSManagedObject, T>, rhs: T) -> NSPredicate {
    NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: lhs), rightExpression: NSExpression(forConstantValue: rhs), modifier: .direct, type: .equalTo)
}
