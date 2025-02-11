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
                Text("给第一次坐飞机的朋友")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("欢迎使用飞行指南！\n我们将为您提供详细的乘机流程指导")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onStart) {
                Text("开始")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}
