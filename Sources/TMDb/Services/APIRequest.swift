//
//  APIRequest.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

protocol APIRequest: Identifiable, Equatable {

    associatedtype Body: Encodable & Equatable
    associatedtype Response: Decodable

    var id: UUID { get }
    var path: String { get }
    var queryItems: APIRequestQueryItems { get }
    var method: APIRequestMethod { get }
    var headers: [String: String] { get }
    var body: Body? { get }
    var serialiser: any Serialiser { get }

}

enum APIRequestMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

typealias APIRequestQueryItems = [String: String]