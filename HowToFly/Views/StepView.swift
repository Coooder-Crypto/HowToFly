import SwiftUI

struct StepView: View {
    let step: FlightStep
    let isLastStep: Bool
    let onComplete: () -> Void
    @Binding var completedTips: Set<UUID>
    @State private var showingIncompleteWarning = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Image(systemName: step.icon)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                    
                    Text(step.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Description
                Text(step.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // Images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(step.images, id: \.self) { colorName in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(colorName))
                                .frame(width: 200, height: 150)
                                .overlay(
                                    Text("示例图片")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Tips
                VStack(alignment: .leading, spacing: 16) {
                    Text("注意事项")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(step.tips) { tip in
                        TipRow(
                            tip: tip,
                            isCompleted: completedTips.contains(tip.id),
                            showWarning: $showingIncompleteWarning,
                            onToggle: { completed in
                                if completed {
                                    completedTips.insert(tip.id)
                                } else {
                                    completedTips.remove(tip.id)
                                }
                            }
                        )
                    }
                }
                .padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                if isLastStep {
                    Button(action: onComplete) {
                        Text("完成")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                Spacer(minLength: 40)
            }
        }
        .alert("请完成所有必要步骤", isPresented: $showingIncompleteWarning) {
            Button("好的", role: .cancel) { }
        }
    }
}

struct TipRow: View {
    let tip: Tip
    let isCompleted: Bool
    @Binding var showWarning: Bool
    let onToggle: (Bool) -> Void
    
    @State private var isShaking = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if tip.type == .todo {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
                    .onTapGesture {
                        onToggle(!isCompleted)
                    }
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
            }
            
            Text(tip.content)
                .font(.subheadline)
                .foregroundColor(tip.type == .todo && !isCompleted ? .primary : .secondary)
            
            Spacer()
        }
        .padding(.horizontal)
        .modifier(ShakeEffect(shaking: isShaking))
        .onChange(of: showWarning) { oldValue, newValue in
            if newValue && tip.type == .todo && !isCompleted {
                withAnimation(.default.repeatCount(3)) {
                    isShaking = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isShaking = false
                }
            }
        }
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var shaking: Bool
    
    var animatableData: CGFloat {
        get { CGFloat(shaking ? 1 : 0) }
        set { }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        guard shaking else { return ProjectionTransform(.identity) }
        let translation = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
