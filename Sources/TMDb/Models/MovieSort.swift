import Foundation

///
/// A sort specifier when fetching movies.
///
public enum MovieSort: CustomStringConvertible {

    ///
    /// By popularity.
    ///
    case popularity(descending: Bool = true)

    ///
    /// By release date.
    ///
    case releaseDate(descending: Bool = true)

    ///
    /// By primary release date.
    ///
    case primaryReleaseDate(descending: Bool = true)

    ///
    /// By revenue.
    ///
    case revenue(descending: Bool = true)

    ///
    /// By original title.
    ///
    case originalTitle(descending: Bool = true)

    ///
    /// By vote average.
    ///
    case voteAverage(descending: Bool = true)

    ///
    /// By vote count.
    ///
    case voteCount(descending: Bool = true)

    public var description: String {
        "\(fieldName).\(isDescending ? "desc" : "asc")"
    }

}

extension MovieSort {

    private var fieldName: String {
        switch self {
        case .popularity:
            return "popularity"

        case .releaseDate:
            return "release_date"

        case .primaryReleaseDate:
            return "primary_release_date"

        case .revenue:
            return "revenue"

        case .originalTitle:
            return "original_title"

        case .voteAverage:
            return "vote_average"

        case .voteCount:
            return "vote_count"
        }
    }

    private var isDescending: Bool {
        switch self {
        case .popularity(let descending):
            return descending

        case .releaseDate(let descending):
            return descending

        case .revenue(let descending):
            return descending

        case .primaryReleaseDate(let descending):
            return descending

        case .originalTitle(let descending):
            return descending

        case .voteAverage(let descending):
            return descending

        case .voteCount(let descending):
            return descending
        }
    }

}

extension URL {

    private enum QueryItemName {
        static let sortBy = "sort_by"
    }

    func appendingSortBy(_ sortBy: MovieSort?) -> Self {
        guard let sortBy else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.sortBy, value: sortBy)
    }

}
