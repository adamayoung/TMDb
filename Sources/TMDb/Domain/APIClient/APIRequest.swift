//
//  APIRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

package protocol APIRequest: Identifiable, Equatable {

    associatedtype Body: Encodable & Equatable
    associatedtype Response: Decodable

    var id: UUID { get }
    var path: String { get }
    var queryItems: [String: String] { get }
    var method: APIRequestMethod { get }
    var headers: [String: String] { get }
    var body: Body? { get }

}
