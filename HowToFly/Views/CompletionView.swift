import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    var onBackToHome: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 16) {
                Text("Have a Great Journey!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text("You've completed all the pre-flight steps.\nWishing you a pleasant flight!")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .lineSpacing(6)
            }
            .padding(.horizontal, 24)
            
            Button(action: {
                dismiss()
                onBackToHome()
            }) {
                HStack {
                    Image(systemName: "house.circle.fill")
                    Text("Back to Home")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .cornerRadius(12)
                .shadow(color: .accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}
