import Foundation

enum TipType {
    case todo
    case warning
}

struct Tip: Identifiable, Hashable {
    let id = UUID()
    let content: String
    let type: TipType
    var isCompleted: Bool = false
    
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
    let images: [String] // 暂时使用颜色名称作为图片占位符
    
    static let steps: [FlightStep] = [
        FlightStep(
            id: 0,
            title: "找到正确航站楼",
            description: "根据您的机票信息确认正确的航站楼和楼层",
            icon: "building.2",
            tips: [
                Tip(content: "检查机票上的航站楼信息（T1或T2）", type: .todo),
                Tip(content: "注意航站楼内的指示牌", type: .warning),
                Tip(content: "如有疑问可咨询机场工作人员", type: .warning)
            ],
            images: ["blue", "gray"]
        ),
        FlightStep(
            id: 1,
            title: "办理值机",
            description: "在值机柜台或自助值机机器办理登机手续",
            icon: "ticket",
            tips: [
                Tip(content: "准备好有效身份证件", type: .todo),
                Tip(content: "选择心仪的座位", type: .todo),
                Tip(content: "确认行李是否符合托运要求", type: .warning),
                Tip(content: "打印登机牌", type: .todo)
            ],
            images: ["green", "orange"]
        ),
        FlightStep(
            id: 2,
            title: "安检",
            description: "通过机场安检确保飞行安全",
            icon: "shield.checkerboard",
            tips: [
                Tip(content: "准备好登机牌和身份证件", type: .todo),
                Tip(content: "取出电子设备和液体", type: .todo),
                Tip(content: "注意液体不超过100ml", type: .warning),
                Tip(content: "金属物品需要单独过检", type: .warning)
            ],
            images: ["red", "purple"]
        ),
        FlightStep(
            id: 3,
            title: "登机",
            description: "找到正确的登机口并排队登机",
            icon: "airplane",
            tips: [
                Tip(content: "确认登机口位置", type: .todo),
                Tip(content: "注意登机时间", type: .warning),
                Tip(content: "按照登机顺序排队", type: .warning),
                Tip(content: "准备好登机牌和证件", type: .todo)
            ],
            images: ["yellow", "mint"]
        ),
        FlightStep(
            id: 4,
            title: "系好安全带",
            description: "正确佩戴安全带确保飞行安全",
            icon: "belt.double",
            tips: [
                Tip(content: "调整安全带松紧度", type: .todo),
                Tip(content: "确保安全带扣紧", type: .todo),
                Tip(content: "全程系好安全带", type: .warning),
                Tip(content: "遵守机组人员指示", type: .warning)
            ],
            images: ["indigo", "cyan"]
        ),
        FlightStep(
            id: 5,
            title: "取回行李",
            description: "在目的地机场领取托运行李",
            icon: "bag",
            tips: [
                Tip(content: "查看行李转盘号码", type: .todo),
                Tip(content: "确认行李标签", type: .todo),
                Tip(content: "如行李丢失及时报失", type: .warning),
                Tip(content: "检查行李完整性", type: .todo)
            ],
            images: ["brown", "teal"]
        )
    ]
}
