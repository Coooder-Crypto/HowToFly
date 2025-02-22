import SwiftUI

struct TutorialStepView: View {
    let currentStep: Int
    let onStepChange: (Int) -> Void
    @State private var offset: CGFloat = 0
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            Color(hex: "DAF5FF")
                .ignoresSafeArea()
            
            VStack {
                // 横向滚动容器
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(0..<FlightStep.steps.count, id: \.self) { index in
                            StepView(
                                step: FlightStep.steps[index],
                                isLastStep: index == FlightStep.steps.count - 1,
                                onComplete: {},
                                isTransitioning: .constant(false),
                                transitionDirection: .constant(0),
                                dragProgress: 0
                            )
                            .frame(width: geometry.size.width)
                        }
                    }
                    .offset(x: -CGFloat(currentStep) * geometry.size.width + offset)
                }
                
                Spacer()
                
                // Step indicators
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
                    
                    // 边缘阻尼效果
                    if (currentStep == 0 && translation > 0) ||
                        (currentStep == FlightStep.steps.count - 1 && translation < 0) {
                        offset = translation * 0.2
                    } else {
                        offset = translation
                    }
                }
                .onEnded { value in
                    let translation = value.translation.width
                    let threshold = screenWidth * 0.3
                    
                    withAnimation(.easeOut(duration: 0.2)) {
                        if translation > threshold && currentStep > 0 {
                            onStepChange(currentStep - 1)
                        } else if translation < -threshold && currentStep < FlightStep.steps.count - 1 {
                            onStepChange(currentStep + 1)
                        }
                        offset = 0
                    }
                }
        )
    }
}
