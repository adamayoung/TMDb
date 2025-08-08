//
//  SearchService.swift
//  TMDb
//
//  Copyright © 2024 MLabs.
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
/// Provides an interface for searching content from TMDb with external IDs..
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol FindService: Sendable {
    
    /// https://api.themoviedb.org/3/find/tt11952708?external_source=imdb_id'
    ///
    
    func findId(_ id: String, type: FindServiceType) async throws -> FindResponse 
}
