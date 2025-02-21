import SwiftUI
import Foundation

struct TutorialStepView: View {
    let currentStep: Int
    let onStepChange: (Int) -> Void
    @State private var dragOffset: CGFloat = 0
    @State private var isTransitioning = false
    @State private var transitionDirection = 0
    @State private var dragProgress: CGFloat = 0
    
    var body: some View {
        ZStack {

            Color(hex: "DAF5FF")
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                StepView(
                    step: FlightStep.steps[currentStep],
                    isLastStep: currentStep == FlightStep.steps.count - 1,
                    onComplete: { },
                    isTransitioning: $isTransitioning,
                    transitionDirection: $transitionDirection,
                    dragProgress: dragProgress
                )
                .offset(x: dragOffset)
                
                Spacer()
                
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
                    let translation = value.translation.width
                    dragOffset = translation
                    
                    dragProgress = translation / UIScreen.main.bounds.width
                    
                    if (currentStep == 0 && dragProgress > 0) ||
                        (currentStep == FlightStep.steps.count - 1 && dragProgress < 0) {
                        dragOffset = translation * 0.2 
                        dragProgress = dragProgress * 0.2
                    }
                }
                .onEnded { value in
                    let translation = value.translation.width
                    let velocity = value.predictedEndTranslation.width
                    let threshold: CGFloat = UIScreen.main.bounds.width * 0.3
                    
                    var shouldChangePage = false
                    if abs(translation) > threshold || abs(velocity) > 800 {
                        if (translation > 0 && currentStep > 0) ||
                            (translation < 0 && currentStep < FlightStep.steps.count - 1) {
                            shouldChangePage = true
                        }
                    }
                    
                    if shouldChangePage {
                        let newStep = translation > 0 ? currentStep - 1 : currentStep + 1
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = translation > 0 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width
                            dragProgress = translation > 0 ? 1.0 : -1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onStepChange(newStep)
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                dragOffset = 0
                                dragProgress = 0
                            }
                        }
                    } else {
                    
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = 0
                            dragProgress = 0
                        }
                    }
                }
        )
    }
}
