import SwiftUI

enum SkyColor: RawRepresentable {
    case day
    case dusk
    case night

    typealias RawValue = [Color]

    var rawValue: [Color] {
        switch self {
        case .day:
            return [.dayTop, .dayBottom]
        case .dusk:
            return [.duskTop, .duskBottom]
        case .night:
            return [.nightTop, .nightBottom]
        }
    }

    init?(rawValue: [Color]) {
        switch rawValue {
        case SkyColor.day.rawValue:
            self = .day
        case SkyColor.dusk.rawValue:
            self = .dusk
        case SkyColor.night.rawValue:
            self = .night
        default:
            return nil
        }
    }
}
