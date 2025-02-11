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
    @State private var showingIncompleteWarning = false
    
    private let steps = FlightStep.steps
    private let generator = UINotificationFeedbackGenerator()
    
    // 检查特定步骤是否有未完成的TODO项
    private func hasUncompletedTodos(in step: FlightStep) -> Bool {
        let todoTips = step.tips.filter { $0.type == .todo }
        return todoTips.contains { !completedTips.contains($0.id) }
    }
    
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
                VStack(spacing: 0) {
                    // 主要内容
                    StepView(
                        step: steps[currentStep],
                        isLastStep: currentStep == steps.count - 1,
                        onComplete: {
                            withAnimation {
                                currentScreen = .completion
                            }
                        },
                        completedTips: $completedTips
                    )
                    .padding(.bottom, 20)
                    
                    // 底部导航栏
                    HStack {
                        // 后退按钮
                        if currentStep > 0 {
                            NavigationButton(
                                action: {
                                    withAnimation {
                                        currentStep -= 1
                                    }
                                },
                                icon: "chevron.left",
                                isEnabled: true
                            )
                        }
                        
                        Spacer()
                        
                        // 步骤指示器
                        HStack(spacing: 8) {
                            ForEach(0..<steps.count, id: \.self) { index in
                                Circle()
                                    .fill(currentStep == index ? Color.accentColor : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(currentStep == index ? 1.2 : 1.0)
                            }
                        }
                        
                        Spacer()
                        
                        // 前进或完成按钮
                        if currentStep < steps.count - 1 {
                            NavigationButton(
                                action: {
                                    if hasUncompletedTodos(in: steps[currentStep]) {
                                        if !showingIncompleteWarning {
                                            generator.notificationOccurred(.warning)
                                            withAnimation {
                                                showingIncompleteWarning = true
                                            }
                                            
                                            // 短暂延迟后隐藏警告
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                withAnimation {
                                                    showingIncompleteWarning = false
                                                }
                                            }
                                        }
                                    } else {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                },
                                icon: "chevron.right",
                                isEnabled: !hasUncompletedTodos(in: steps[currentStep])
                            )
                        } else {
                            NavigationButton(
                                action: {
                                    withAnimation {
                                        currentScreen = .completion
                                    }
                                },
                                icon: "checkmark",
                                isEnabled: !hasUncompletedTodos(in: steps[currentStep])
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        Color(.systemBackground)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
                    )
                }
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
                
            case .completion:
                CompletionView()
            }
        }
        .animation(.default, value: currentScreen)
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
