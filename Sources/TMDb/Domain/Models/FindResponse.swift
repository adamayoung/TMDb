//
//  SearchResponse.swift
//  TMDb
//
//  Created by MLabs on 23/06/2025.
//


import Foundation

// MARK: - Main Response Structure
public struct FindResponse: Codable {
    let movieResults: [MovieResult]
    let personResults: [PersonResult]
    let tvResults: [TVResult]
    let tvEpisodeResults: [TVEpisodeResult]
    let tvSeasonResults: [TVSeasonResult]
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
        case personResults = "person_results"
        case tvResults = "tv_results"
        case tvEpisodeResults = "tv_episode_results"
        case tvSeasonResults = "tv_season_results"
    }
}

// MARK: - TV Episode Result
public struct TVEpisodeResult: Codable {
    let id: Int
    let name: String
    let overview: String
    let mediaType: String
    let voteAverage: Double
    let voteCount: Int
    let airDate: String
    let episodeNumber: Int
    let episodeType: String
    let productionCode: String
    let runtime: Int?
    let seasonNumber: Int
    let showId: Int
    let stillPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case mediaType = "media_type"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showId = "show_id"
        case stillPath = "still_path"
    }
}

// MARK: - Person Result
public struct PersonResult: Codable {
    let id: Int
    let name: String
    let originalName: String
    let mediaType: String
    let adult: Bool
    let popularity: Double
    let gender: Int
    let knownForDepartment: String
    let profilePath: String?
    let knownFor: [KnownForItem]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case mediaType = "media_type"
        case adult, popularity, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - Known For Item
public struct KnownForItem: Codable {
    let backdropPath: String?
    let id: Int
    let mediaType: String
    let adult: Bool
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let overview: String
    let posterPath: String?
    
    // Pre filmy
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let video: Bool?
    
    // Pre seriály
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let originCountry: [String]?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case overview
        case posterPath = "poster_path"
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case video
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

// MARK: - Movie Result
public struct MovieResult: Codable {
    let backdropPath: String?
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let mediaType: String
    let adult: Bool
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - TV Result
public struct TVResult: Codable {
    let backdropPath: String?
    let id: Int
    let name: String
    let originalName: String
    let overview: String
    let posterPath: String?
    let mediaType: String
    let adult: Bool
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, name
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}

// MARK: - TV Season Result
public struct TVSeasonResult: Codable {
    let id: Int
    /// TODO:
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
