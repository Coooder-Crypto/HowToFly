//
//  ContentView.swift
//  HowToFly
//
//  Created by Coooder on 2025/2/11.
//

import SwiftUI

struct ContentView: View {
    @State private var currentStep = 0
    @State private var showWelcome = true
    
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
                    onStepChange: { newStep in
                        withAnimation {
                            currentStep = newStep
                        }
                    },
                    onBackToHome: {
                        withAnimation {
                            showWelcome = true
                            currentStep = 0
                        }
                    }
                )
            }
        }
        .animation(.default, value: showWelcome)
    }
}

#Preview {
    ContentView()
}
