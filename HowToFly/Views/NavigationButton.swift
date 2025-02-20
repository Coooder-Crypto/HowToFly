import SwiftUI

struct NavigationButton: View {
    let action: () -> Void
    let icon: String
    let isEnabled: Bool
    
    init(action: @escaping () -> Void, icon: String, isEnabled: Bool) {
        self.action = action
        self.icon = icon
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(isEnabled ? Color.accentColor : Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                )
        }
        .opacity(isEnabled ? 1.0 : 0.5)
        .disabled(!isEnabled)
    }
}
