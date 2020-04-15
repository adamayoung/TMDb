//
//  TVShowSeason.swift
//  TMDb
//
//  Created by Adam Young on 15/04/2020.
//

import Foundation

public struct TVShowSeason: Identifiable, Decodable {

  public let id: Int
  public let name: String
  public let seasonNumber: Int
  public let overview: String?
  public let airDate: Date?
  public let posterPath: URL?
  public let episodes: [Episode]

  public init(id: Int, name: String, seasonNumber: Int, overview: String, airDate: Date? = nil, posterPath: URL? = nil, episodes: [TVShowSeason.Episode] = []) {
    self.id = id
    self.name = name
    self.seasonNumber = seasonNumber
    self.overview = overview
    self.airDate = airDate
    self.posterPath = posterPath
    self.episodes = episodes
  }

}

extension TVShowSeason {

  public struct Episode: Identifiable, Decodable {

    public let id: Int
    public let name: String
    public let episodeNumber: Int
    public let seasonNumber: Int
    public let showId: Int
    public let overview: String?
    public let airDate: Date?
    public let productionCode: String?
    public let stillPath: URL?
    public let crew: [CrewMember]
    public let guestStars: [CastMember]
    public let voteAverage: Float
    public let voteCount: Int

    public init(id: Int, name: String, episodeNumber: Int, seasonNumber: Int, showId: Int, overview: String?, airDate: Date?, productionCode: String?, stillPath: URL?, crew: [CrewMember], guestStars: [CastMember], voteAverage: Float, voteCount: Int) {
      self.id = id
      self.name = name
      self.episodeNumber = episodeNumber
      self.seasonNumber = seasonNumber
      self.showId = showId
      self.overview = overview
      self.airDate = airDate
      self.productionCode = productionCode
      self.stillPath = stillPath
      self.crew = crew
      self.guestStars = guestStars
      self.voteAverage = voteAverage
      self.voteCount = voteCount
    }
  }

}
