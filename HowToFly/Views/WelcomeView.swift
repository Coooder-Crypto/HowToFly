import SwiftUI

struct WelcomeView: View {
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "airplane.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.accentColor)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 16) {
                Text("First-Time Flyer's Guide")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text("Welcome to the Flight Guide!\nWe'll walk you through the step-by-step process of flying.")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .lineSpacing(6)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: onStart) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    Image(systemName: "arrow.right.circle.fill")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .cornerRadius(12)
                .shadow(color: .accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}
