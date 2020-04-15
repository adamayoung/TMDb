//
//  TVShowListResultItem.swift
//  TMDb
//
//  Created by Adam Young on 21/01/2020.
//

import Foundation

public struct TVShowListResultItem: Identifiable, Decodable {

  public let id: Int
  public let name: String
  public let originalName: String?
  public let originalLanguage: String?
  public let overview: String?
  public let genreIds: [Int]?
  public let firstAirDate: Date?
  public let originCountry: [String]?
  public let posterPath: URL?
  public let backdropPath: URL?
  public let popularity: Float?
  public let voteAverage: Float?
  public let voteCount: Int?

  public init(id: Int, name: String, originalName: String? = nil, originalLanguage: String? = nil, overview: String? = nil, genreIds: [Int]? = nil, firstAirDate: Date? = nil, originCountry: [String]? = nil, posterPath: URL? = nil, backdropPath: URL? = nil, popularity: Float? = nil, voteAverage: Float? = nil, voteCount: Int? = nil) {
    self.id = id
    self.name = name
    self.originalName = originalName
    self.originalLanguage = originalLanguage
    self.overview = overview
    self.genreIds = genreIds
    self.firstAirDate = firstAirDate
    self.originCountry = originCountry
    self.posterPath = posterPath
    self.backdropPath = backdropPath
    self.popularity = popularity
    self.voteAverage = voteAverage
    self.voteCount = voteCount
  }

}
