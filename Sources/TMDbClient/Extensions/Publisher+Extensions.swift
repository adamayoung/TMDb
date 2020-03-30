//
//  Publisher+Extensions.swift
//  TMDbClient
//
//  Created by Adam Young on 30/03/2020.
//

import Combine
import Foundation

extension URLSession.DataTaskPublisher {

  func mapAPIError() -> AnyPublisher<Output, APIError> {
    self
      .mapError { APIError.network($0) }
      .flatMap { (data, response) -> AnyPublisher<Output, APIError> in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard statusCode != 200 else {
          return Just((data, response))
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
        }

        let error: APIError = {
          switch statusCode {
          case 401:
            return .unauthorized

          case 404:
            return .notFound

          default:
            return .unknown
          }
        }()

        return Fail(outputType: Output.self, failure: error)
          .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }

}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {

  func mapResponse<Output: Decodable>(to outputType: Output.Type, decoder: JSONDecoder)
    -> AnyPublisher<Output, APIError> {
      self
        .map { $0.data }
        .decode(type: outputType, decoder: decoder)
        .mapError { APIError.decode($0) }
        .eraseToAnyPublisher()
  }

}
