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
    
    private func tipIndicator(icon: String, title: String, color: Color, textColor: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(textColor)
            
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(.label))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(color.opacity(colorScheme == .dark ? 0.2 : 1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(colorScheme == .dark ? 0.5 : 0), lineWidth: 1)
        )
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1E1E1E") : Color(hex: "DAF5FF")
    }
    
    var circleColor: Color {
        colorScheme == .dark ? Color(hex: "2E2E2E") : Color(hex: "B0DAFF")
    }
    
    private func layoutParameters(for size: CGSize) -> (centerRadius: CGFloat, tipRadius: CGFloat) {
        let centerRadius: CGFloat = 110 
        let tipRadius = size.width * 0.35
        return (centerRadius, tipRadius)
    }
    
    private func tipParameters(in size: CGSize, for index: Int, tip: Tip, progress: CGFloat) -> (position: CGPoint, size: CGFloat, scale: CGFloat) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let (_, tipRadius) = layoutParameters(for: size)
        
        let angles: [Double] = [45, 135, 225, 315]
        let radian = angles[index] * .pi / 180.0
        
        let targetX = centerX + CGFloat(Darwin.cos(radian)) * tipRadius
        let targetY = centerY + CGFloat(Darwin.sin(radian)) * tipRadius
        
        let margin: CGFloat = 80
        let adjustedX = max(margin, min(size.width - margin, targetX))
        let adjustedY = max(margin, min(size.height - margin, targetY))
        
        let currentX = centerX + (adjustedX - centerX) * (1 - abs(progress))
        let currentY = centerY + (adjustedY - centerY) * (1 - abs(progress))
        
        let scale = 1 - abs(progress) * 0.3
        
        return (CGPoint(x: currentX, y: currentY), tip.size, scale)
    }
    
    private func tipTransform(for index: Int, in geometry: GeometryProxy) -> (scale: CGFloat, opacity: CGFloat) {
        let progress = abs(dragProgress)
        
        let scale = 1.0 - progress * 0.5
        let opacity = 1.0 - progress
        
        return (scale: scale, opacity: opacity)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                ForEach(Array(step.tips.enumerated()), id: \.element.id) { index, tip in
                    let transform = tipTransform(for: index, in: geometry)
                    
                    let animationProgress = isTransitioning ? (transitionDirection < 0 ? dragProgress : -dragProgress) : 0
                    let params = tipParameters(in: geometry.size, for: index, tip: tip, progress: animationProgress)
                    TipCircle(
                        tip: tip,
                        size: params.size
                    )
                    .position(params.position)
                    .scaleEffect(params.scale)
                    .opacity(1 - abs(dragProgress) * 0.8)
                }
                
                ZStack {
                    Circle()
                        .fill(circleColor)
                        .frame(width: 220, height: 220)
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
                    
                    VStack(spacing: 12) {
                        Text(step.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.label))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Text(step.description)
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                            .multilineTextAlignment(.center)
                            .frame(width: 180)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .scaleEffect(1.0 - abs(dragProgress) * 0.2)
                .opacity(1.0 - abs(dragProgress) * 0.5)
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 20) {
                            tipIndicator(
                                icon: "checkmark.circle.fill",
                                title: "To-Do Steps",
                                color: colorScheme == .dark ? .blue : Color(hex: "B9E9FC"),
                                textColor: .blue
                            )
                            
                            if step.tips.contains(where: { $0.type == .warning }) {
                                tipIndicator(
                                    icon: "exclamationmark.triangle.fill",
                                    title: "Important Notes",
                                    color: colorScheme == .dark ? .yellow : Color(hex: "FEFF86"),
                                    textColor: .orange
                                )
                            }
                        }
                        .padding(.horizontal, 36)
                        
                        if isLastStep {
                            Button(action: {
                                showingCompletion = true
                            }) {
                                HStack {
                                    Text("FINISH")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    Image(systemName: "checkmark.circle.fill")
                                }
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(colorScheme == .dark ? Color.white : Color.accentColor)
                                .cornerRadius(12)
                                .shadow(color: (colorScheme == .dark ? Color.white : Color.accentColor).opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.top, 24)
                        }
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showingCompletion) {
                CompletionView(onBackToHome: onComplete)
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
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size, height: size)
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
                
                VStack(spacing: 8) {
                    Image(systemName: tip.icon)
                        .font(.system(size: size * 0.12))
                        .foregroundColor(
                            tip.type == .warning ? (colorScheme == .dark ? .yellow : .orange) : (colorScheme == .dark ? .blue : .blue)
                        )
                    
                    Text(tip.content)
                        .font(.system(size: size * 0.07))
                        .foregroundColor(Color(.label))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: size * 0.7)
                }
            }
        }
    }

