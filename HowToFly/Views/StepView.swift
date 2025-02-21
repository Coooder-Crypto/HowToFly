import SwiftUI
import Foundation
import CoreGraphics

struct StepView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let step: FlightStep
    let isLastStep: Bool
    let onComplete: () -> Void
    @Binding var isTransitioning: Bool
    @Binding var transitionDirection: Int
    let dragProgress: CGFloat
    @State private var showingCompletion = false
    
    // 动态背景颜色
    var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1E1E1E") : Color(hex: "DAF5FF")
    }
    
    // 主圆圈颜色
    var circleColor: Color {
        colorScheme == .dark ? Color(hex: "2E2E2E") : Color(hex: "B0DAFF")
    }
    
    // 固定位置布局
    private func tipPosition(in size: CGSize, for index: Int) -> CGPoint {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let radius: CGFloat = min(size.width, size.height) * 0.43
        
        let baseAngle = Double(step.id) * 12.0
        let angles: [Double] = [45, 135, 225, 315]
        let angle = angles[index] + baseAngle
        let radian = angle * .pi / 180.0
        
        return CGPoint(
            x: centerX + CGFloat(Darwin.cos(radian)) * radius,
            y: centerY + CGFloat(Darwin.sin(radian)) * radius
        )
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
                backgroundColor
                    .ignoresSafeArea()
                
                // Tips 圆圈
                ForEach(Array(step.tips.enumerated()), id: \.element.id) { index, tip in
                    let transform = tipTransform(for: index, in: geometry)
                    
                    TipCircle(
                        tip: tip,
                        size: tip.size
                    )
                    .position(tipPosition(in: geometry.size, for: index))
                    .scaleEffect(transform.scale)
                    .opacity(transform.opacity)
                }
                
                // 主圆圈（标题和描述）
                Circle()
                    .fill(circleColor)
                    .frame(width: 220, height: 220)
                    .overlay(
                        VStack(spacing: 12) {
                            Text(step.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.label)) // 动态文本颜色
                                .multilineTextAlignment(.center)
                            
                            Text(step.description)
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel)) // 动态副文本颜色
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    )
                    .shadow(
                        color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.white.opacity(0.8),
                        radius: 15,
                        x: -10,
                        y: -10
                    )
                    .shadow(
                        color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1),
                        radius: 15,
                        x: 10,
                        y: 10
                    )
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .scaleEffect(1.0 - abs(dragProgress) * 0.2)
                    .opacity(1.0 - abs(dragProgress) * 0.5)
                
                // Finish Button
                if isLastStep {
                    VStack {
                        Spacer()
                        Button(action: {
                            showingCompletion = true
                        }) {
                            HStack {
                                Text("FINISH")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                Image(systemName: "checkmark.circle.fill")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .shadow(color: .accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showingCompletion) {
            CompletionView()
        }
    }
}

struct TipCircle: View {
    @Environment(\.colorScheme) var colorScheme
    
    let tip: Tip
    let size: CGFloat
    
    private var backgroundColor: Color {
        switch tip.type {
        case .todo:
            return colorScheme == .dark ? Color(hex: "1C1C1C") : Color(hex: "B9E9FC")
        case .warning:
            return colorScheme == .dark ? Color(hex: "5E5E5E") : Color(hex: "FEFF86")
        }
    }
    
    var body: some View {
        Circle()
            .fill(backgroundColor)
            .frame(width: size, height: size)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: tip.icon)
                        .font(.system(size: 24))
                        .foregroundColor(
                            tip.type == .warning ? (colorScheme == .dark ? .yellow : .orange) : (colorScheme == .dark ? .blue : .blue)
                        ) // 动态图标颜色
                    
                    Text(tip.content)
                        .font(.footnote)
                        .foregroundColor(Color(.label)) // 动态文本颜色
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(16)
            )
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.white.opacity(0.8),
                radius: 15,
                x: -10,
                y: -10
            )
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1),
                radius: 15,
                x: 10,
                y: 10
            )
    }
}
