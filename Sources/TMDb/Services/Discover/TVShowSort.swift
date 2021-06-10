import Foundation

/// Sort specifier when fetching TV shows.
public enum TVShowSort: CustomStringConvertible {

    /// Default sort specifier.
    public static var `default`: Self = .popularity()

    /// By popularity.
    case popularity(descending: Bool = true)
    /// By first air date.
    case firstAirDate(descending: Bool = true)
    /// By vote average.
    case voteAverage(descending: Bool = true)

    public var description: String {
        "\(fieldName).\(isDescending ? "desc" : "asc")"
    }

}

extension TVShowSort {

    private var fieldName: String {
        switch self {
        case .popularity:
            return "popularity"

        case .firstAirDate:
            return "first_air_date"

        case .voteAverage:
            return "vote_average"
        }
    }

    private var isDescending: Bool {
        switch self {
        case .popularity(let descending):
            return descending

        case .firstAirDate(let descending):
            return descending

        case .voteAverage(let descending):
            return descending
        }
    }

}

extension URL {

    func appendingSortBy(_ sortBy: TVShowSort?) -> Self {
        guard let sortBy = sortBy else {
            return self
        }

        return appendingQueryItem(name: "sort_by", value: sortBy)
    }

}
