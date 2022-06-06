import Foundation

/// Sort specifier when fetching TV shows.
public enum TrendingTimeWindowFilterType: String {

    /// Default trending time window filter.
    public static var `default`: Self = .day

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
