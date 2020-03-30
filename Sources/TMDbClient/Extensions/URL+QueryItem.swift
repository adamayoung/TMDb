//
//  URL+QueryItem.swift
//  TMDbClient
//
//  Created by Adam Young on 21/01/2020.
//

import Foundation

extension URL {

  func appendingQueryItem(name: String, value: String) -> Self {
    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
    var queryItems = urlComponents.queryItems ?? []
    queryItems.append(URLQueryItem(name: name, value: value))
    urlComponents.queryItems = queryItems
    return urlComponents.url!
  }

}

extension URL {

  func appendingAPIKeyQueryItem(_ apiKey: String) -> Self {
    appendingQueryItem(name: "api_key", value: apiKey)
  }

}
