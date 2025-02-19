//
//  ContentView.swift
//  HowToFly
//
//  Created by Coooder on 2025/2/11.
//

import SwiftUI

enum AppScreen {
    case welcome
    case tutorial
    case completion
}

struct ContentView: View {
    @State private var currentStep = 0
    @State private var showWelcome = true
    @State private var completedTips = Set<UUID>()
    @State private var showingIncompleteWarning = false
    
    private let steps = FlightStep.steps
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView {
                    withAnimation {
                        showWelcome = false
                    }
                }
            } else {
                TutorialStepView(
                    currentStep: currentStep,
                    hasUncompletedTodos: hasUncompletedTodos,
                    onStepChange: { newStep in
                        withAnimation {
                            currentStep = newStep
                        }
                    }
                )
                .overlay(alignment: .top) {
                    if showingIncompleteWarning {
                        Text("请完成所有必要步骤")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.red)
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 8)
                    }
                }
            }
        }
        .animation(.default, value: showWelcome)
    }
    
    // 检查是否有未完成的TODO项
    private var hasUncompletedTodos: Bool {
        let todoTips = FlightStep.steps[currentStep].tips.filter { $0.type == .todo }
        return todoTips.contains { !completedTips.contains($0.id) }
    }
}

struct NavigationButton: View {
    let action: () -> Void
    let icon: String
    let isEnabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(isEnabled ? .white : .gray)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isEnabled ? Color.accentColor : Color.gray.opacity(0.2))
                )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    ContentView()
}
