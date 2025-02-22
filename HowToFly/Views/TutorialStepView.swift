import SwiftUI

struct TutorialStepView: View {
    @Environment(\.colorScheme) var colorScheme
    let currentStep: Int
    let onStepChange: (Int) -> Void
    let onBackToHome: () -> Void
    @State private var offset: CGFloat = 0
    @State private var dragDirection: Int = 0 // -1: 向左拖动, 1: 向右拖动
    @State private var isTransitioning = false
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? Color(hex: "1E1E1E") : Color(hex: "DAF5FF"))
                .ignoresSafeArea()
            
            VStack {
                // 横向滚动容器
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(0..<FlightStep.steps.count, id: \.self) { index in
                            StepView(
                                step: FlightStep.steps[index],
                                isLastStep: index == FlightStep.steps.count - 1,
                                onComplete: onBackToHome,
                                isTransitioning: .constant(isTransitioning),
                                transitionDirection: .constant(dragDirection),
                                dragProgress: offset / geometry.size.width
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
                            .fill(index == currentStep 
                                  ? (colorScheme == .dark ? Color.white : Color(hex: "B0DAFF")) 
                                  : (colorScheme == .dark ? Color.gray.opacity(0.3) : Color(hex: "B9E9FC")))
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
                    
                    // 更新拖动方向
                    dragDirection = translation > 0 ? 1 : -1
                    isTransitioning = true
                    
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
                    let velocity = value.predictedEndTranslation.width / screenWidth
                    let threshold = screenWidth * 0.25 // 降低滑动距离阈值
                    
                    // 如果滑动速度很快，降低阈值
                    let adjustedThreshold = abs(velocity) > 1.0 ? threshold * 0.6 : threshold
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if (translation > adjustedThreshold || velocity > 1.0) && currentStep > 0 {
                            onStepChange(currentStep - 1)
                        } else if (translation < -adjustedThreshold || velocity < -1.0) && currentStep < FlightStep.steps.count - 1 {
                            onStepChange(currentStep + 1)
                        }
                        offset = 0
                        isTransitioning = false
                    }
                }
        )
    }
}
