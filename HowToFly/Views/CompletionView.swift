import SwiftUI

struct CompletionView: View {
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
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea()) 
    }
}
