//
//  IMDbLink.swift
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
/// An IMDb external link.
///
/// e.g. to a movie's IMDb page.
///
public struct IMDbLink: ExternalLink {

    ///
    /// IMDb identifier.
    ///
    public let id: String

    ///
    /// URL of the IMDb web page.
    ///
    public let url: URL

    ///
    /// Creates an IMDb link object using an IMDb title identifier.
    ///
    /// e.g. for a movie or TV series.
    ///
    /// - Parameter imdbTitleID: The IMDb movie or TV series identifier.
    ///
    public init?(imdbTitleID: String?) {
        guard
            let imdbTitleID,
            let url = Self.imdbURL(forTitle: imdbTitleID)
        else {
            return nil
        }

        self.init(id: imdbTitleID, url: url)
    }

    ///
    /// Creates an IMDb link object using an IMDb name identifier.
    ///
    /// e.g. for a person.
    ///
    /// - Parameter imdbNameID: The IMDb person identifier.
    ///
    public init?(imdbNameID: String?) {
        guard
            let imdbNameID,
            let url = Self.imdbURL(forName: imdbNameID)
        else {
            return nil
        }

        self.init(id: imdbNameID, url: url)
    }

}

extension IMDbLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension IMDbLink {

    private static func imdbURL(forTitle imdbTitleID: String) -> URL? {
        URL(string: "https://www.imdb.com/title/\(imdbTitleID)/")
    }

    private static func imdbURL(forName nameID: String) -> URL? {
        URL(string: "https://www.imdb.com/name/\(nameID)/")
    }

}
