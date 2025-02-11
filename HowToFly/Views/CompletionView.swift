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
                Text("祝您旅途愉快")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("您已完成所有乘机准备步骤\n祝您有一个愉快的航程！")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}
