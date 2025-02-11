import Foundation

struct FlightStep: Identifiable {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let tips: [String]
    
    static let steps: [FlightStep] = [
        FlightStep(
            id: 0,
            title: "找到正确航站楼",
            description: "根据您的机票信息确认正确的航站楼和楼层",
            icon: "building.2",
            tips: ["检查机票上的航站楼信息（T1或T2）", "注意航站楼内的指示牌", "如有疑问可咨询机场工作人员"]
        ),
        FlightStep(
            id: 1,
            title: "办理值机",
            description: "在值机柜台或自助值机机器办理登机手续",
            icon: "ticket",
            tips: ["准备好有效身份证件", "提前选择心仪的座位", "确认行李是否符合托运要求", "打印登机牌"]
        ),
        FlightStep(
            id: 2,
            title: "安检",
            description: "通过机场安检确保飞行安全",
            icon: "shield.checkerboard",
            tips: ["准备好登机牌和身份证件", "取出电子设备和液体", "注意液体不超过100ml", "金属物品需要单独过检"]
        ),
        FlightStep(
            id: 3,
            title: "登机",
            description: "找到正确的登机口并排队登机",
            icon: "airplane",
            tips: ["提前确认登机口位置", "注意登机时间", "按照登机顺序排队", "准备好登机牌和证件"]
        ),
        FlightStep(
            id: 4,
            title: "系好安全带",
            description: "正确佩戴安全带确保飞行安全",
            icon: "belt.double",
            tips: ["调整安全带松紧度", "确保安全带扣紧", "全程系好安全带", "遵守机组人员指示"]
        ),
        FlightStep(
            id: 5,
            title: "取回行李",
            description: "在目的地机场领取托运行李",
            icon: "bag",
            tips: ["查看行李转盘号码", "确认行李标签", "如行李丢失及时报失", "检查行李完整性"]
        )
    ]
}
