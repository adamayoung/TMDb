//
//  APIError.swift
//  TMDbClient
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation
import os.log

public enum APIError: Error {

  case network(URLError)
  case unauthorized
  case notFound
  case unknown
  case decode(Error)

}
