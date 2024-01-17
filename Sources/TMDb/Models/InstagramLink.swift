//
//  InstagramLink.swift
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
/// An Instagram external link.
///
/// e.g. to a movie's Instagram profile.
///
public struct InstagramLink: ExternalLink {

    ///
    /// Instagram profile identifier.
    ///
    public let id: String

    ///
    /// URL of the Instagram profile page.
    ///
    public let url: URL

    ///
    /// Creates an Instagram link object using an Instagram profile identifier.
    ///
    /// - Parameter instagramID: The Instagram profile identifier.
    ///
    public init?(instagramID: String?) {
        guard
            let instagramID,
            let url = Self.instagramURL(for: instagramID)
        else {
            return nil
        }

        self.init(id: instagramID, url: url)
    }

}

extension InstagramLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension InstagramLink {

    private static func instagramURL(for instagramID: String) -> URL? {
        URL(string: "https://www.instagram.com/\(instagramID)")
    }

}
