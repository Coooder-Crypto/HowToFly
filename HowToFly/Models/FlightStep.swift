import Foundation

enum TipType {
    case todo
    case warning
}

struct TipImage: Equatable {
    let imageName: String
    let description: String
}

struct Tip: Identifiable, Hashable, Equatable {
    static func == (lhs: Tip, rhs: Tip) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let content: String
    let type: TipType
    let images: [TipImage]?  // nil 表示没有图片
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func createTip(content: String, type: TipType, withImages: Bool) -> Tip {
        if withImages {
            // Mock images
            let images = [
                TipImage(imageName: "mock_image_1", description: "示例图片1"),
                TipImage(imageName: "mock_image_2", description: "示例图片2")
            ]
            return Tip(content: content, type: type, images: images)
        } else {
            return Tip(content: content, type: type, images: nil)
        }
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
            title: "找到正确航站楼",
            description: "根据您的机票信息确认正确的航站楼和楼层，请注意观察机场指示牌",
            icon: "building.2",
            tips: [
                createTip(step: "找到航站楼", type: .todo, hasImages: true),
                createTip(step: "确认登机口", type: .todo, hasImages: false),
                createTip(step: "注意航班时间", type: .warning, hasImages: true),
                createTip(step: "关注天气情况", type: .warning, hasImages: false)
            ]
        ),
        FlightStep(
            id: 1,
            title: "办理值机手续",
            description: "在值机柜台或自助值机机器办理登机手续，准备好您的证件",
            icon: "ticket",
            tips: [
                createTip(step: "准备证件", type: .todo, hasImages: true),
                createTip(step: "选择座位", type: .todo, hasImages: false),
                createTip(step: "行李重量", type: .warning, hasImages: true),
                createTip(step: "物品限制", type: .warning, hasImages: false)
            ]
        ),
        FlightStep(
            id: 2,
            title: "通过安检",
            description: "请按照安检要求准备好随身物品，配合安检人员工作",
            icon: "shield.checkerboard",
            tips: [
                createTip(step: "取出电子设备", type: .todo, hasImages: true),
                createTip(step: "脱掉外套", type: .todo, hasImages: false),
                createTip(step: "液体限制", type: .warning, hasImages: true),
                createTip(step: "违禁品", type: .warning, hasImages: false)
            ]
        ),
        FlightStep(
            id: 3,
            title: "找到登机口",
            description: "根据登机牌上的信息找到正确的登机口，注意登机时间",
            icon: "airplane",
            tips: [
                createTip(step: "确认登机口", type: .todo, hasImages: true),
                createTip(step: "准备登机牌", type: .todo, hasImages: false),
                createTip(step: "登机顺序", type: .warning, hasImages: true),
                createTip(step: "行李尺寸", type: .warning, hasImages: false)
            ]
        )
    ]
    
    private static func createTip(step: String, type: TipType, hasImages: Bool) -> Tip {
        Tip.createTip(content: step, type: type, withImages: hasImages)
    }
}
