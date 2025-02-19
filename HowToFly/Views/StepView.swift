import SwiftUI
import Foundation

struct StepView: View {
    let step: FlightStep
    let isLastStep: Bool
    let onComplete: () -> Void
    @Binding var completedTips: Set<UUID>
    @Binding var isTransitioning: Bool
    @Binding var transitionDirection: Int // -1: 向左, 1: 向右
    
    // 固定位置布局
    private func tipPosition(in size: CGSize, for index: Int) -> CGPoint {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let radius: CGFloat = min(size.width, size.height) * 0.42 // 增加半径，让tip更外围
        
        // 根据步骤ID和tip索引确定固定角度，使用45度的偏移确保在四个角
        let baseAngle = Double(step.id) * 12.0 // 每个步骤旋转12度
        let angles: [Double] = [45, 135, 225, 315] // 四个角的基础角度
        let angle = angles[index] + baseAngle
        let radian = angle * .pi / 180.0
        
        return CGPoint(
            x: centerX + CGFloat(Darwin.cos(radian)) * radius,
            y: centerY + CGFloat(Darwin.sin(radian)) * radius
        )
    }
    
    // 固定大小
    private func circleSize(for tip: Tip) -> CGFloat {
        if tip.images != nil {
            return tip.type == .todo ? 180 : 160 // 带图片的圆形更大
        } else {
            return 120 // 不带图片的圆形较小
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景色
                Color(hex: "DAF5FF")
                    .ignoresSafeArea()
                
                // Tips 圆圈
                ForEach(Array(step.tips.enumerated()), id: \.element.id) { index, tip in
                    let isCompleted = completedTips.contains(tip.id)
                    
                    TipCircle(
                        tip: tip,
                        isCompleted: isCompleted,
                        size: circleSize(for: tip),
                        onToggle: { completed in
                            withAnimation(.spring()) {
                                if completed {
                                    completedTips.insert(tip.id)
                                } else {
                                    completedTips.remove(tip.id)
                                }
                            }
                        }
                    )
                    .position(tipPosition(in: geometry.size, for: index))
                    .scaleEffect(isTransitioning ? (transitionDirection > 0 ? 0 : 2) : 1)
                    .opacity(isTransitioning ? 0 : 1)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isTransitioning)
                }
                
                // 主圆圈（标题和描述）
                Circle()
                    .fill(Color(hex: "B0DAFF"))
                    .frame(width: 220, height: 220)
                    .overlay(
                        VStack(spacing: 12) {
                            Text(step.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text(step.description)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    )
                    .shadow(color: .white.opacity(0.8), radius: 15, x: -10, y: -10)
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 10, y: 10)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .ignoresSafeArea()
    }
}

struct TipCircle: View {
    let tip: Tip
    let isCompleted: Bool
    let size: CGFloat
    let onToggle: (Bool) -> Void
    
    private var backgroundColor: Color {
        switch (tip.type, isCompleted) {
        case (.todo, true):
            return Color(hex: "B9E9FC")
        case (.todo, false):
            return .clear
        case (.warning, _):
            return Color(hex: "FEFF86")
        }
    }
    
    private var strokeColor: Color {
        if tip.type == .todo && !isCompleted {
            return Color(hex: "B9E9FC")
        }
        return .clear
    }
    
    var body: some View {
        Circle()
            .fill(backgroundColor)
            .overlay(
                Circle()
                    .strokeBorder(strokeColor, lineWidth: 3)
            )
            .frame(width: size, height: size)
            .overlay(
                VStack(spacing: 8) {
                    if let images = tip.images {
                        TabView {
                            ForEach(images, id: \.imageName) { image in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.red.opacity(0.3))
                                    )
                            }
                        }
                        .frame(height: size * 0.4)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    
                    Text(tip.content)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(16)
            )
            .shadow(color: .white.opacity(0.8), radius: 15, x: -10, y: -10)
            .shadow(color: .black.opacity(0.1), radius: 15, x: 10, y: 10)
            .onTapGesture {
                if tip.type == .todo {
                    onToggle(!isCompleted)
                }
            }
    }
}
