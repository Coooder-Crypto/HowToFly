import SwiftUI

struct PaperPlaneTransition: AnimatableModifier {
    var offset: CGFloat
    var rotation: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, rotation) }
        set {
            offset = newValue.first
            rotation = newValue.second
        }
    }
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0),
                anchor: offset > 0 ? .leading : .trailing,
                perspective: 0.5
            )
            .offset(x: offset)
    }
}

extension View {
    func paperPlaneTransition(offset: CGFloat) -> some View {
        modifier(PaperPlaneTransition(
            offset: offset,
            rotation: offset / UIScreen.main.bounds.width * 45
        ))
    }
}
