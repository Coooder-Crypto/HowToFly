import SwiftUI

struct StepView: View {
    let step: FlightStep
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Image(systemName: step.icon)
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
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
            VStack(alignment: .leading, spacing: 16) {
                Text("注意事项")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(step.tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(tip)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
