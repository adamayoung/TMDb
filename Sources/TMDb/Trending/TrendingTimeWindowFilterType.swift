import Foundation

/// Sort specifier when fetching TV series.
public enum TrendingTimeWindowFilterType: String {

    /// Day time window filter.
    case day
    /// Week time window filter.
    case week

}

extension URL {

    func appendingPathComponent(_ filterType: TrendingTimeWindowFilterType) -> Self {
        appendingPathComponent(filterType.rawValue)
    }

}
