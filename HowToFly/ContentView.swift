//
//  ContentView.swift
//  HowToFly
//
//  Created by Coooder on 2025/2/11.
//

import SwiftUI

struct ContentView: View {
    @State private var currentStep = 0
    private let steps = FlightStep.steps
    
    var body: some View {
        TabView(selection: $currentStep) {
            ForEach(steps) { step in
                StepView(step: step)
                    .tag(step.id)
            }
        }
        .tabViewStyle(.page)
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
    }
}

#Preview {
    ContentView()
}
