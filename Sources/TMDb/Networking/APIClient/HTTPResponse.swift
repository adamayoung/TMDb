//
//  HTTPResponse.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the License );
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
/// A model representing an HTTP response.
///
public struct HTTPResponse {

    ///
    /// The HTTP status code of the response.
    ///
    public let statusCode: Int

    ///
    /// Data returned in the response body.
    ///
    public let data: Data?

    ///
    /// Creates an HTTP response object.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code of the response.
    ///   - data: Data returned in the response body.
    ///
    public init(statusCode: Int = 200, data: Data? = nil) {
        self.statusCode = statusCode
        self.data = data
    }

}
