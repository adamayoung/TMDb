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

    private enum FieldName {
        static let popularity = "popularity"
        static let firstAirDate = "first_air_date"
        static let voteAverage = "vote_average"
    }

    private var fieldName: String {
        switch self {
        case .popularity:
            return FieldName.popularity

        case .firstAirDate:
            return FieldName.firstAirDate

        case .voteAverage:
            return FieldName.voteAverage
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

    private enum QueryItemName {
        static let sortBy = "sort_by"
    }

    func appendingSortBy(_ sortBy: TVShowSort?) -> Self {
        guard let sortBy = sortBy else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.sortBy, value: sortBy)
    }

}
