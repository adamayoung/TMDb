//
//  MovieListResultItem.swift
//  TMDb
//
//  Created by Adam Young on 07/01/2020.
//  Copyright © 2020 Adam Young. All rights reserved.
//

import Foundation

public struct MovieListResultItem: Identifiable, Decodable {

    private let releaseDateString: String?

    public let id: Int
    public let title: String
    public let originalTitle: String?
    public let originalLanguage: String?
    public let overview: String?
    public let genreIDs: [Int]?
    public var releaseDate: Date? {
        guard let releaseDateString = releaseDateString else {
            return nil
        }

        return DateFormatter.theMovieDatabase.date(from: releaseDateString)
    }
    public let posterPath: URL?
    public let backdropPath: URL?
    public let popularity: Float?
    public let voteAverage: Float?
    public let voteCount: Int?
    public let video: Bool?
    public let adult: Bool?

    public init(id: Int, title: String, originalTitle: String? = nil, originalLanguage: String? = nil, overview: String? = nil, genreIDs: [Int]? = nil, releaseDate: Date? = nil, posterPath: URL? = nil, backdropPath: URL? = nil, popularity: Float? = nil, voteAverage: Float? = nil, voteCount: Int? = nil, video: Bool? = nil, adult: Bool? = nil) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.genreIDs = genreIDs
        self.releaseDateString = {
            guard let releaseDate = releaseDate else {
                return nil
            }

            return DateFormatter.theMovieDatabase.string(from: releaseDate)
        }()
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.video = video
        self.adult = adult
    }

}

extension MovieListResultItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle
        case originalLanguage
        case overview
        case genreIDs
        case releaseDateString = "releaseDate"
        case posterPath
        case backdropPath
        case popularity
        case voteAverage
        case voteCount
        case video
        case adult
    }

}
