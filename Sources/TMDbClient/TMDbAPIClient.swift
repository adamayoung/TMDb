//
//  TMDbAPIClient.swift
//  TMDbClient
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbAPIClient {

  private static let baseURL = URL(string: "https://api.themoviedb.org/3")!

  private let urlSession: URLSession
  private let jsonDecoder: JSONDecoder

  private(set) var apiKey: String = ""

  public static let shared = TMDbAPIClient()

  init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .theMovieDatabase) {
    self.urlSession = urlSession
    self.jsonDecoder = jsonDecoder
  }

  public func setAPIKey(_ apiKey: String) {
    self.apiKey = apiKey
  }

}

extension TMDbAPIClient {

  public func get<Response: Decodable>(path: URL,
                                       httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, Error> {
    let url = urlFromPath(path)
    var urlRequest = URLRequest(url: url)

    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    httpHeaders?.forEach { (key: String, value: String) in
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }

    return urlSession.dataTaskPublisher(for: urlRequest)
      .mapAPIError()
      .mapResponse(to: Response.self, decoder: jsonDecoder)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }

}

extension TMDbAPIClient {

  private func urlFromPath(_ path: URL) -> URL {
    guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
      return path
    }

    urlComponents.scheme = Self.baseURL.scheme
    urlComponents.host = Self.baseURL.host
    urlComponents.path = Self.baseURL.path + "\(urlComponents.path)"

    return urlComponents.url!
      .appendingAPIKeyQueryItem(apiKey)
  }

}
