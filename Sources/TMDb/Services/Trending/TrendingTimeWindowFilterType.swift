import Foundation

public enum TrendingTimeWindowFilterType: String {

    case day
    case week

    public static var `default`: Self = .day

}

extension URL {

    func appendingPathComponent(_ filterType: TrendingTimeWindowFilterType) -> Self {
        appendingPathComponent(filterType.rawValue)
    }

}
