//
//  WikiDataLink.swift
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

///
/// A WikiData external link.
///
/// e.g. to a movie's WikiData page.
///
public struct WikiDataLink: ExternalLink {

    ///
    /// WikiData page identifier.
    ///
    public let id: String

    ///
    /// URL of the WikiData web page.
    ///
    public let url: URL

    ///
    /// Creates a WikiData link object using a WikiData page identifier.
    ///
    /// - Parameter wikiDataID: The WikiData page identifier.
    ///
    public init?(wikiDataID: String?) {
        guard
            let wikiDataID,
            let url = Self.wikiDataURL(for: wikiDataID)
        else {
            return nil
        }

        self.init(id: wikiDataID, url: url)
    }

}

extension WikiDataLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension WikiDataLink {

    private static func wikiDataURL(for id: String) -> URL? {
        URL(string: "https://www.wikidata.org/wiki/\(id)")
    }

}
