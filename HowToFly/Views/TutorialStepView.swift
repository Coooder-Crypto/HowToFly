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
            // 背景色
            Color(hex: "DAF5FF")
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                // 步骤内容
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
                    let translation = value.translation.width
                    dragOffset = translation
                    
                    // 计算拖动进度 (-1.0 到 1.0)
                    dragProgress = translation / UIScreen.main.bounds.width
                    
                    // 限制拖动范围
                    if (currentStep == 0 && dragProgress > 0) ||
                        (currentStep == FlightStep.steps.count - 1 && dragProgress < 0) {
                        dragOffset = translation * 0.2 // 增加阻尼效果
                        dragProgress = dragProgress * 0.2
                    }
                }
                .onEnded { value in
                    let translation = value.translation.width
                    let velocity = value.predictedEndTranslation.width
                    let threshold: CGFloat = UIScreen.main.bounds.width * 0.3
                    
                    // 判断是否需要切换页面
                    var shouldChangePage = false
                    if abs(translation) > threshold || abs(velocity) > 800 {
                        if (translation > 0 && currentStep > 0) ||
                            (translation < 0 && currentStep < FlightStep.steps.count - 1) {
                            shouldChangePage = true
                        }
                    }
                    
                    if shouldChangePage {
                        // 切换页面
                        let newStep = translation > 0 ? currentStep - 1 : currentStep + 1
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = translation > 0 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width
                            dragProgress = translation > 0 ? 1.0 : -1.0
                        }
                        
                        // 延迟切换以等待动画完成
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onStepChange(newStep)
                            
                            // 重置位置
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                dragOffset = 0
                                dragProgress = 0
                            }
                        }
                    } else {
                        // 回到原位
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = 0
                            dragProgress = 0
                        }
                    }
                }
        )
    }
}
