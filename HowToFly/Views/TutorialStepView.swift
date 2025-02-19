import SwiftUI

struct TutorialStepView: View {
    let step: FlightStep
    let isLastStep: Bool
    let currentStep: Int
    let onComplete: () -> Void
    let onStepChange: (Int) -> Void
    @Binding var completedTips: Set<UUID>
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging = false
    
    // 检查是否有未完成的TODO项
    private var hasUncompletedTodos: Bool {
        let todoTips = step.tips.filter { $0.type == .todo }
        return todoTips.contains { !completedTips.contains($0.id) }
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color(hex: "DAF5FF")
                .ignoresSafeArea()
            
            StepView(
                step: step,
                isLastStep: isLastStep,
                onComplete: onComplete,
                completedTips: $completedTips
            )
            .paperPlaneTransition(offset: dragOffset)
            .gesture(
                DragGesture()
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        handleDragChange(value)
                    }
                    .onEnded { value in
                        handleDragEnd(value)
                    }
            )
            
            // 进度指示器
            HStack(spacing: 8) {
                ForEach(0..<FlightStep.steps.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentStep ? Color(hex: "B0DAFF") : Color(hex: "B9E9FC"))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    private func handleDragChange(_ value: DragGesture.Value) {
        if hasUncompletedTodos {
            dragOffset = 0
        } else {
            dragOffset = value.translation.width
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        if !hasUncompletedTodos {
            let threshold: CGFloat = 50
            if abs(value.translation.width) > threshold {
                if value.translation.width > 0 && currentStep > 0 {
                    onStepChange(currentStep - 1)
                } else if value.translation.width < 0 && currentStep < FlightStep.steps.count - 1 {
                    onStepChange(currentStep + 1)
                }
            }
        }
        
        withAnimation(.spring()) {
            dragOffset = 0
        }
    }
}
