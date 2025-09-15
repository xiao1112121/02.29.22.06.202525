import Foundation

struct Event: Codable, Identifiable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var isAllDay: Bool
    var color: EventColor
    
    init(title: String, description: String = "", date: Date, startTime: Date, endTime: Date, isAllDay: Bool = false, color: EventColor = .blue) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.isAllDay = isAllDay
        self.color = color
    }
}

enum EventColor: String, CaseIterable, Codable {
    case blue = "blue"
    case red = "red"
    case green = "green"
    case orange = "orange"
    case purple = "purple"
    case pink = "pink"
    case yellow = "yellow"
    case gray = "gray"
    
    var uiColor: UIColor {
        switch self {
        case .blue:
            return .systemBlue
        case .red:
            return .systemRed
        case .green:
            return .systemGreen
        case .orange:
            return .systemOrange
        case .purple:
            return .systemPurple
        case .pink:
            return .systemPink
        case .yellow:
            return .systemYellow
        case .gray:
            return .systemGray
        }
    }
    
    var name: String {
        switch self {
        case .blue:
            return "Xanh dương"
        case .red:
            return "Đỏ"
        case .green:
            return "Xanh lá"
        case .orange:
            return "Cam"
        case .purple:
            return "Tím"
        case .pink:
            return "Hồng"
        case .yellow:
            return "Vàng"
        case .gray:
            return "Xám"
        }
    }
}