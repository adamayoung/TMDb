import Foundation

public enum MovieSortBy: String {

    case popularityAscending = "popularity.asc"
    case popularityDescending = "popularity.desc"

    case releaseDateAscending = "release_date.asc"
    case releaseDateDescending = "release_date.desc"

    case revenueAscending = "revenue.asc"
    case revenueDescending = "revenue.desc"

    case primaryReleaseDateAscending = "primary_release_date.asc"
    case primaryReleaseDateDescending = "primary_release_date.desc"

    case originalTitleAscending = "original_title.asc"
    case originalTitleDescending = "original_title.desc"

    case voteAverageAscending = "vote_average.asc"
    case voteAverageDescending = "vote_average.desc"

    case voteCountAscending = "vote_count.asc"
    case voteCountDescending = "vote_count.desc"

    public static var `default`: Self = .popularityDescending

}

extension URL {

    func appendingSortBy(_ sortBy: MovieSortBy?) -> Self {
        guard let sortBy = sortBy else {
            return self
        }

        return appendingQueryItem(name: "sort_by", value: sortBy.rawValue)
    }

}
