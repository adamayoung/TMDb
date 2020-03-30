//
//  Movie.swift
//  TMBdMovies
//
//  Created by Adam Young on 23/01/2020.
//

import Foundation

public struct Movie: Identifiable, Decodable {

  public let id: Int
  public let title: String
  public let tagline: String?
  public let originalTitle: String
  public let originalLanguage: String
  public let overview: String?
  public let runtime: Int?
  public let genres: [Genre]
  public let releaseDate: Date
  public let posterPath: URL?
  public let backdropPath: URL?
  public let budget: Float
  public let revenue: Float
  private let homepage: String?
  public let imdbId: String?
  public let status: Status
  public let productionCompanies: [ProductionCompany]
  public let productionCountries: [ProductionCountry]
  public let spokenLanguages: [SpokenLanguage]
  public let popularity: Float
  public let voteAverage: Float
  public let voteCount: Int
  public let video: Bool
  public let adult: Bool

  public init(id: Int, title: String, tagline: String? = nil, originalTitle: String, originalLanguage: String,
              overview: String? = nil, runtime: Int? = nil, genres: [Genre], releaseDate: Date, posterPath: URL? = nil,
              backdropPath: URL? = nil, budget: Float, revenue: Float, homepageURL: URL? = nil, imdbId: String? = nil,
              status: Status, productionCompanies: [ProductionCompany], productionCountries: [ProductionCountry],
              spokenLanguages: [SpokenLanguage], popularity: Float, voteAverage: Float, voteCount: Int, video: Bool,
              adult: Bool) {
    self.id = id
    self.title = title
    self.tagline = tagline
    self.originalTitle = originalTitle
    self.originalLanguage = originalLanguage
    self.overview = overview
    self.runtime = runtime
    self.genres = genres
    self.releaseDate = releaseDate
    self.posterPath = posterPath
    self.backdropPath = backdropPath
    self.budget = budget
    self.revenue = revenue
    self.homepage = homepageURL?.absoluteString
    self.imdbId = imdbId
    self.status = status
    self.productionCompanies = productionCompanies
    self.productionCountries = productionCountries
    self.spokenLanguages = spokenLanguages
    self.popularity = popularity
    self.voteAverage = voteAverage
    self.voteCount = voteCount
    self.video = video
    self.adult = adult
  }

}

extension Movie {

  public var homepageURL: URL? {
    guard let homepage = homepage else {
      return nil
    }

    return URL(string: homepage)
  }

}
