//
//  TrendingTimeWindowFilterType.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public enum TrendingTimeWindowFilterType: String {

  case day
  case week

  public static var `default`: Self = .week

}

extension TrendingTimeWindowFilterType: CustomStringConvertible {

  public var description: String {
    rawValue
  }

}
