import Foundation

enum BodyType: String, CaseIterable {
    case slim = "Slim"
    case lean = "Lean"
    case normal = "Normal"
    case chubby = "Chubby"
    case overweight = "Overweight"
    
    var weightMultiplier: Double {
        switch self {
        case .slim: return 0.6
        case .lean: return 0.8
        case .normal: return 1.0
        case .chubby: return 1.2
        case .overweight: return 1.4
        }
    }
    
    var iconName: String {
        switch self {
        case .slim: return "body_type_slim"
        case .lean: return "body_type_lean"
        case .normal: return "body_type_normal"
        case .chubby: return "body_type_chubby"
        case .overweight: return "body_type_overweight"
        }
    }
}
