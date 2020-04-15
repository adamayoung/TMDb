//
//  Person.swift
//  TMDb
//
//  Created by Adam Young on 23/01/2020.
//

import Foundation

public struct Person: Identifiable, Decodable {

  public let id: Int
  public let name: String
  public let alsoKnownAs: [String]
  public let knownForDepartment: String?
  public let biography: String
  public let birthday: Date?
  public let deathday: Date?
  public let gender: Gender
  public let placeOfBirth: String?
  public let profilePath: URL?
  public let popularity: Float
  public let imdbId: String
  public let homepage: URL?

  public init(id: Int, name: String, alsoKnownAs: [String] = [], knownForDepartment: String? = nil, biography: String,
              birthday: Date, deathday: Date? = nil, gender: Gender = .unknown, placeOfBirth: String? = nil,
              profilePath: URL? = nil, popularity: Float, imdbId: String, homepage: URL? = nil) {
    self.id = id
    self.name = name
    self.alsoKnownAs = alsoKnownAs
    self.knownForDepartment = knownForDepartment
    self.biography = biography
    self.birthday = birthday
    self.deathday = deathday
    self.gender = gender
    self.placeOfBirth = placeOfBirth
    self.profilePath = profilePath
    self.popularity = popularity
    self.imdbId = imdbId
    self.homepage = homepage
  }

}
