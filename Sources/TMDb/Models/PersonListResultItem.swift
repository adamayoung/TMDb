//
//  PersonListResultItem.swift
//  TMDb
//
//  Created by Adam Young on 21/01/2020.
//

import Foundation

public struct PersonListResultItem: Identifiable, Decodable {

    public let id: Int
    public let name: String?
    public let profilePath: URL?
    public let knownFor: [KnownForItem]?
    public let popularity: Float?
    public let adult: Bool?

    public init(id: Int, name: String? = nil, profilePath: URL? = nil, knownFor: [KnownForItem]? = nil,
                popularity: Float? = nil, adult: Bool? = nil) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.knownFor = knownFor
        self.popularity = popularity
        self.adult = adult
    }

}

extension PersonListResultItem {

    public enum KnownForItem: Identifiable {

        public var id: String {
            switch self {
            case .movie(let movie):
                return "movie-\(movie.id)"

            case .tvShow(let tvShow):
                return "tvShow-\(tvShow.id)"
            }
        }

        case movie(MovieListResultItem)
        case tvShow(TVShowListResultItem)
    }

}

extension PersonListResultItem.KnownForItem: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable {
        case movie
        case tvShow = "tv"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try MovieListResultItem(from: decoder))

        case .tvShow:
            self = .tvShow(try TVShowListResultItem(from: decoder))
        }
    }

}
