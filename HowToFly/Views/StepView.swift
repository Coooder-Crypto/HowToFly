import SwiftUI

struct StepView: View {
    let step: FlightStep
    let isLastStep: Bool
    let onComplete: () -> Void
    @Binding var completedTips: Set<UUID>
    @State private var showingIncompleteWarning = false
    
    // Haptic feedback generators
    private let warningHaptic = UINotificationFeedbackGenerator()
    private let selectionHaptic = UISelectionFeedbackGenerator()
    
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
                
                // Tips
                VStack(alignment: .leading, spacing: 20) {
                    Text("注意事项")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(step.tips) { tip in
                            TipRow(
                                tip: tip,
                                isCompleted: completedTips.contains(tip.id),
                                showWarning: $showingIncompleteWarning,
                                onToggle: { completed in
                                    selectionHaptic.selectionChanged()
                                    if completed {
                                        completedTips.insert(tip.id)
                                    } else {
                                        completedTips.remove(tip.id)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .onChange(of: showingIncompleteWarning) { newValue in
            if newValue {
                warningHaptic.notificationOccurred(.warning)
            }
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
        VStack(alignment: .leading, spacing: 12) {
            // Tip header with icon and text
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
            
            // Tip images in a grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 8) {
                ForEach(0..<2) { _ in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.2), lineWidth: 1)
                        )
                        .aspectRatio(4/3, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.red.opacity(0.3))
                        )
                }
            }
        }
        .padding(.horizontal)
        .modifier(ShakeEffect(shaking: isShaking))
        .onChange(of: showWarning) { newValue in
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
