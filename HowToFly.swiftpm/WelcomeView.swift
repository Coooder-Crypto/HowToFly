import SwiftUI

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "airplane.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.accentColor)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 16) {
                Text("Welcome to HowToFly")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text("First time flying? Don’t worry, I’ve got you!\n\nFollow step-by-step guidance for a smooth and stress-free journey.")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .lineSpacing(6)
                    .padding(.horizontal, 24)
            }

            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: onStart) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    Image(systemName: "arrow.right.circle.fill")
                }
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(colorScheme == .dark ? .white : Color.accentColor)
                .cornerRadius(12)
                .shadow(color: (colorScheme == .dark ? Color.white : Color.accentColor).opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
        .padding(.bottom, 70)
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}
