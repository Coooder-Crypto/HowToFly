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
    @State private var currentScreen: AppScreen = .welcome
    @State private var currentStep = 0
    @State private var completedTips = Set<UUID>()
    
    private let steps = FlightStep.steps
    
    var body: some View {
        Group {
            switch currentScreen {
            case .welcome:
                WelcomeView {
                    withAnimation {
                        currentScreen = .tutorial
                    }
                }
                
            case .tutorial:
                TabView(selection: $currentStep) {
                    ForEach(steps) { step in
                        StepView(
                            step: step,
                            isLastStep: step.id == steps.count - 1,
                            onComplete: {
                                withAnimation {
                                    currentScreen = .completion
                                }
                            },
                            completedTips: $completedTips
                        )
                        .tag(step.id)
                    }
                }
                .tabViewStyle(.page)
                .onChange(of: currentStep) { oldStep, newStep in
                    let currentStepItem = steps[newStep]
                    if currentStepItem.hasUncompletedTodos {
                        // Revert back to the current step if there are uncompleted todos
                        currentStep = oldStep
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .overlay(alignment: .bottom) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Circle()
                                .fill(currentStep == index ? Color.accentColor : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentStep == index ? 1.2 : 1.0)
                                .animation(.spring(), value: currentStep)
                        }
                    }
                    .padding(.bottom, 20)
                }
                
            case .completion:
                CompletionView()
            }
        }
        .animation(.default, value: currentScreen)
    }
}

#Preview {
    ContentView()
}
