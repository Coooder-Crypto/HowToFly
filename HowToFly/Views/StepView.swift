import SwiftUI
import Foundation

struct StepView: View {
    let step: FlightStep
    let isLastStep: Bool
    let onComplete: () -> Void
    @Binding var isTransitioning: Bool
    @Binding var transitionDirection: Int
    let dragProgress: CGFloat
    
    // 固定位置布局
    private func tipPosition(in size: CGSize, for index: Int) -> CGPoint {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let radius: CGFloat = min(size.width, size.height) * 0.42
        
        let baseAngle = Double(step.id) * 12.0
        let angles: [Double] = [45, 135, 225, 315]
        let angle = angles[index] + baseAngle
        let radian = angle * .pi / 180.0
        
        return CGPoint(
            x: centerX + CGFloat(Darwin.cos(radian)) * radius,
            y: centerY + CGFloat(Darwin.sin(radian)) * radius
        )
    }
    
    private func circleSize(for tip: Tip) -> CGFloat {
        if tip.images != nil {
            return 180
        } else {
            return 120
        }
    }
    
    private func tipTransform(for index: Int, in geometry: GeometryProxy) -> (scale: CGFloat, opacity: CGFloat) {
        let direction = dragProgress > 0 ? 1.0 : -1.0
        let progress = abs(dragProgress)
        
        // 计算缩放和透明度
        let scale = 1.0 - progress * 0.5
        let opacity = 1.0 - progress
        
        return (scale: scale, opacity: opacity)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景色
                Color(hex: "DAF5FF")
                    .ignoresSafeArea()
                
                // Tips 圆圈
                ForEach(Array(step.tips.enumerated()), id: \.element.id) { index, tip in
                    let transform = tipTransform(for: index, in: geometry)
                    
                    TipCircle(
                        tip: tip,
                        size: circleSize(for: tip)
                    )
                    .position(tipPosition(in: geometry.size, for: index))
                    .scaleEffect(transform.scale)
                    .opacity(transform.opacity)
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
                    .scaleEffect(1.0 - abs(dragProgress) * 0.2)
                    .opacity(1.0 - abs(dragProgress) * 0.5)
            }
        }
        .ignoresSafeArea()
    }
}

struct TipCircle: View {
    let tip: Tip
    let size: CGFloat
    
    private var backgroundColor: Color {
        switch tip.type {
        case .todo:
            return Color(hex: "B9E9FC")
        case .warning:
            return Color(hex: "FEFF86")
        }
    }
    
    var body: some View {
        Circle()
            .fill(backgroundColor)
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
    }
}
