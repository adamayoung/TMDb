//
//  APIClient.swift
//  TMDbCredits
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol APIClient {

  func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) -> AnyPublisher<Response, Error>

}

extension APIClient {

  func get<Response: Decodable>(path: URL, httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, Error> {
    get(path: path, httpHeaders: httpHeaders)
  }

}

extension APIClient {

  func get<Response: Decodable>(endpoint: Endpoint,
                                httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, Error> {
    get(path: endpoint.url, httpHeaders: httpHeaders)
  }

}
