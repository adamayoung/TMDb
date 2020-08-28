import Foundation

public enum TVShowSortBy: String {

    case voteAverageAscending = "vote_average.asc"
    case voteAverageDescending = "vote_average.desc"

    case firstAirDateAscending = "first_air_date.asc"
    case firstAirDateDescending = "first_air_date.desc"

    case popularityAscending = "popularity.asc"
    case popularityDescending = "popularity.desc"

    public static var `default`: Self = .popularityDescending

}

extension URL {

    func appendingSortBy(_ sortBy: TVShowSortBy?) -> Self {
        guard let sortBy = sortBy else {
            return self
        }

        return appendingQueryItem(name: "sort_by", value: sortBy.rawValue)
    }

}
