//
//  APIClient.swift
//  TMDb
//
//  Created by Adam Young on 08/04/2020.
//

import Combine
import Foundation

public protocol APIClient {

  static func setAPIKey(_ apiKey: String)

  func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) -> AnyPublisher<Response, TMDbError>

}

extension APIClient {

  func get<Response: Decodable>(path: URL, httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, TMDbError> {
    get(path: path, httpHeaders: httpHeaders)
  }

}

extension APIClient {

  func get<Response: Decodable>(endpoint: Endpoint, httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, TMDbError> {
    get(path: endpoint.url, httpHeaders: httpHeaders)
  }

}
