//
//  TwitterLink.swift
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
/// A Twitter external link.
///
/// e.g. to a movie's Twitter profile.
///
public struct TwitterLink: ExternalLink {

    ///
    /// Twitter profile identifier.
    ///
    public let id: String

    ///
    /// URL of the Twitter profile page.
    ///
    public let url: URL

    ///
    /// Creates a Twitter link object using a Twitter profile identifier.
    ///
    /// - Parameter twitterID: The Twitter profile identifier.
    ///
    public init?(twitterID: String?) {
        guard
            let twitterID,
            let url = Self.twitterURL(for: twitterID)
        else {
            return nil
        }

        self.init(id: twitterID, url: url)
    }

}

extension TwitterLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension TwitterLink {

    private static func twitterURL(for twitterID: String) -> URL? {
        URL(string: "https://www.twitter.com/\(twitterID)")
    }

}
