import SwiftUI
import Foundation

struct TutorialStepView: View {
    let currentStep: Int
    let hasUncompletedTodos: Bool
    let onStepChange: (Int) -> Void
    @State private var dragOffset: CGFloat = 0
    @State private var isTransitioning = false
    @State private var transitionDirection = 0
    @State private var completedTips = Set<UUID>()
    
    var body: some View {
        ZStack {
            // 背景色
            Color(hex: "DAF5FF")
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                // 步骤内容
                StepView(
                    step: FlightStep.steps[currentStep],
                    isLastStep: currentStep == FlightStep.steps.count - 1,
                    onComplete: { },
                    completedTips: $completedTips,
                    isTransitioning: $isTransitioning,
                    transitionDirection: $transitionDirection
                )
                
                Spacer()
                
                // 进度指示器
                HStack(spacing: 8) {
                    ForEach(0..<FlightStep.steps.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentStep ? Color(hex: "B0DAFF") : Color(hex: "B9E9FC"))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !hasUncompletedTodos {
                        dragOffset = value.translation.width
                    }
                }
                .onEnded(handleDragEnd)
        )
        .onChange(of: currentStep) { newStep in
            // 重置完成状态
            completedTips.removeAll()
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        if !hasUncompletedTodos {
            let threshold: CGFloat = 50
            if abs(value.translation.width) > threshold {
                isTransitioning = true
                if value.translation.width > 0 && currentStep > 0 {
                    transitionDirection = -1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onStepChange(currentStep - 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTransitioning = false
                        }
                    }
                } else if value.translation.width < 0 && currentStep < FlightStep.steps.count - 1 {
                    transitionDirection = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onStepChange(currentStep + 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTransitioning = false
                        }
                    }
                }
            }
        }
        
        withAnimation(.spring()) {
            dragOffset = 0
        }
    }
}
