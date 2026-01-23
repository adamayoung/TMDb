//
//  NetworkService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

///
/// Provides an interface for obtaining TV network data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol NetworkService: Sendable {

    ///
    /// Returns a TV network's details.
    ///
    /// [TMDb API - Networks: Details](https://developer.themoviedb.org/reference/network-details)
    ///
    /// - Parameter id: The identifier of the TV network.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV network.
    ///
    func details(forNetwork id: Network.ID) async throws -> Network

    ///
    /// Returns a TV network's alternative names.
    ///
    /// [TMDb API - Networks: Alternative Names](https://developer.themoviedb.org/reference/details-copy)
    ///
    /// - Parameter id: The identifier of the TV network.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The alternative names for the TV network.
    ///
    func alternativeNames(forNetwork id: Network.ID) async throws -> [NetworkAlternativeName]

    ///
    /// Returns a TV network's logos.
    ///
    /// [TMDb API - Networks: Images](https://developer.themoviedb.org/reference/alternative-names-copy)
    ///
    /// - Parameter id: The identifier of the TV network.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The logos for the TV network.
    ///
    func images(forNetwork id: Network.ID) async throws -> [NetworkLogo]

}
