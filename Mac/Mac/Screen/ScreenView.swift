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
    
    
    var body: some View {
        VStack {
            Text("\(formatTime(seconds: timerOB.restTimeRemaining))")
                .font(.system(size: 50, weight: .bold))
 
            Text(items.randomElement()?.text ?? "闭眼休息")
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
            }
        }
    }
    
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ScreenView(isPresented: .constant(true))
}

func == <T>(lhs: KeyPath<some NSManagedObject, T>, rhs: T) -> NSPredicate {
    NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: lhs), rightExpression: NSExpression(forConstantValue: rhs), modifier: .direct, type: .equalTo)
}
