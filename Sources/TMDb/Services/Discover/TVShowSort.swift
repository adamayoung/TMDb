import Foundation

public enum TVShowSort: String {

    case popularityAscending = "popularity.asc"
    case popularityDescending = "popularity.desc"

    case firstAirDateAscending = "first_air_date.asc"
    case firstAirDateDescending = "first_air_date.desc"

    case voteAverageAscending = "vote_average.asc"
    case voteAverageDescending = "vote_average.desc"

    public static var `default`: Self = .popularityDescending

}

extension URL {

    func appendingSortBy(_ sortBy: TVShowSort?) -> Self {
        guard let sortBy = sortBy else {
            return self
        }

        return appendingQueryItem(name: "sort_by", value: sortBy.rawValue)
    }

}
