import Foundation

enum TipType {
    case todo
    case warning
}

struct Tip: Identifiable, Hashable, Equatable {
    static func == (lhs: Tip, rhs: Tip) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let content: String
    let type: TipType
    let icon: String  // System icon name for the tip
    let size: CGFloat
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FlightStep: Identifiable {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let tips: [Tip]
    
    static let steps: [FlightStep] = [
        FlightStep(
            id: 0,
            title: "Find the Right Terminal",
            description: "Check your ticket for the correct terminal and floor. Follow airport signs.",
            icon: "building.2",
            tips: [
                createTip(step: "Locate Terminal", type: .todo, icon: "map"),
                createTip(step: "Check Gate Info", type: .todo, icon: "signpost.right"),
                createTip(step: "Watch Flight Time", type: .warning, icon: "clock"),
                createTip(step: "Confirm Airline", type: .warning, icon: "airplane.circle")
            ]
        ),
        FlightStep(
            id: 1,
            title: "Check-In",
            description: "Proceed to the check-in counter or self-service kiosk with your ID.",
            icon: "ticket",
            tips: [
                createTip(step: "Check Bags", type: .todo, icon: "bag"),
                createTip(step: "Select Seat", type: .todo, icon: "chair"),
                createTip(step: "Baggage Rules", type: .warning, icon: "scalemass"),
                createTip(step: "Item Restrictions", type: .warning, icon: "exclamationmark.triangle")
            ]
        ),
        FlightStep(
            id: 2,
            title: "Security Check",
            description: "Prepare your belongings and follow security instructions.",
            icon: "shield.checkerboard",
            tips: [
                createTip(step: "Remove Electronics", type: .todo, icon: "laptopcomputer"),
                createTip(step: "Take Off Jacket", type: .todo, icon: "tshirt"),
                createTip(step: "Liquid Rules", type: .warning, icon: "drop"),
                createTip(step: "Prohibited Items", type: .warning, icon: "xmark.shield")
            ]
        ),
        FlightStep(
            id: 3,
            title: "Board the Plane",
            description: "Find your gate using your boarding pass. Be ready for boarding.",
            icon: "airplane",
            tips: [
                createTip(step: "Confirm Gate", type: .todo, icon: "arrow.right.circle"),
                createTip(step: "Prepare Boarding Pass", type: .todo, icon: "ticket.fill"),
                createTip(step: "Boarding Order", type: .warning, icon: "list.number"),
                createTip(step: "Bag Size Limits", type: .warning, icon: "ruler")
            ]
        )
    ]
    
    private static func createTip(step: String, type: TipType, icon: String) -> Tip {
        let size = CGFloat.random(in: 120...180)
        return Tip(content: step, type: type, icon: icon, size: size)
    }
}
