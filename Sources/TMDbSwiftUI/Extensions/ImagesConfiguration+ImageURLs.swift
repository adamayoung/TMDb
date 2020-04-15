//
//  ImagesConfiguration+ImageURLs.swift
//  TMDbSwiftUI
//
//  Created by Adam Young on 09/04/2020.
//

import CoreGraphics
import Foundation
import TMDb

extension ImagesConfiguration {

  func imageURL(forPosterPath path: URL?, size: CGFloat) -> URL? {
    guard let path = path else {
      return nil
    }

    return secureBaseUrl
      .appendingPathComponent("w780")
      .appendingPathComponent(path.absoluteString)
  }

  func imageURL(forBackdropPath path: URL?) -> URL? {
    guard let path = path else {
      return nil
    }

   return secureBaseUrl
      .appendingPathComponent("w780")
      .appendingPathComponent(path.absoluteString)
  }

  func imageURL(forPersonProfilePath path: URL?, size: CGFloat) -> URL? {
    guard let path = path else {
      return nil
    }

    return secureBaseUrl
      .appendingPathComponent("w780")
      .appendingPathComponent(path.absoluteString)
  }

}
