//
//  APIClient.swift
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

protocol APIClient {

    func get<Response: Decodable>(path: URL) async throws -> Response

    func post<Response: Decodable>(path: URL, body: some Encodable) async throws -> Response

    func delete<Response: Decodable>(path: URL, body: some Encodable) async throws -> Response

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response

}

extension APIClient {

    func get<Response: Decodable>(endpoint: Endpoint) async throws -> Response {
        try await get(path: endpoint.path)
    }

    func post<Response: Decodable>(endpoint: Endpoint, body: some Encodable) async throws -> Response {
        try await post(path: endpoint.path, body: body)
    }

    func delete<Response: Decodable>(endpoint: Endpoint, body: some Encodable) async throws -> Response {
        try await delete(path: endpoint.path, body: body)
    }

}
