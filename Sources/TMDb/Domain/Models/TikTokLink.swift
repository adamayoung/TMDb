//
//  TikTokLink.swift
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
/// A TikTok external link.
///
/// e.g. to a person's TikTok profile.
///
public struct TikTokLink: ExternalLink {

    ///
    /// TikTok profile identifier.
    ///
    public let id: String

    ///
    /// URL of the TikTok profile page.
    ///
    public let url: URL

    ///
    /// Creates a TikTok link object using a TikTok user identifier.
    ///
    /// - Parameter tikTokID: The TikTok user identifier.
    ///
    public init?(tikTokID: String?) {
        guard
            let tikTokID,
            let url = Self.tikTokURL(for: tikTokID)
        else {
            return nil
        }

        self.init(id: tikTokID, url: url)
    }

}

extension TikTokLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension TikTokLink {

    private static func tikTokURL(for tikTokID: String) -> URL? {
        URL(string: "https://www.tiktok.com/@\(tikTokID)")
    }

}
