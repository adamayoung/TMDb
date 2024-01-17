//
//  FacebookLink.swift
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
/// An Facebook external link.
///
/// e.g. to a movie's Facebook profile.
///
public struct FacebookLink: ExternalLink {

    ///
    /// Facebook profile identifier.
    ///
    public let id: String

    ///
    /// URL of the Facebook profile page.
    ///
    public let url: URL

    ///
    /// Creates a Facebook link object using a Facebook profile identifier.
    ///
    /// - Parameter facebookID: The Facebook profile identifier.
    ///
    public init?(facebookID: String?) {
        guard
            let facebookID,
            let url = Self.facebookURL(for: facebookID)
        else {
            return nil
        }

        self.init(id: facebookID, url: url)
    }

}

extension FacebookLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension FacebookLink {

    private static func facebookURL(for facebookID: String) -> URL? {
        URL(string: "https://www.facebook.com/\(facebookID)")
    }

}
