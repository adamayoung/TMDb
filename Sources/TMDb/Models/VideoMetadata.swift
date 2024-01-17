//
//  VideoMetadata.swift
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
/// A model representing details of a video.
///
public struct VideoMetadata: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Video identifier.
    ///
    public let id: String

    ///
    /// Video name.
    ///
    public let name: String

    ///
    /// Site which the video is from.
    ///
    public let site: String

    ///
    /// Site's video identifier.
    ///
    public let key: String

    ///
    /// Video type.
    ///
    public let type: VideoType

    ///
    /// Video size.
    ///
    public let size: VideoSize

    ///
    /// Creates a video metadata object.
    ///
    /// - Parameters:
    ///    - id: Video identifier.
    ///    - name: Video name.
    ///    - site: Site which the video is from.
    ///    - key: Site's video identifier.
    ///    - type: Video type.
    ///    - size: Video size.
    ///
    public init(
        id: String,
        name: String,
        site: String,
        key: String,
        type: VideoType,
        size: VideoSize
    ) {
        self.id = id
        self.name = name
        self.site = site
        self.key = key
        self.type = type
        self.size = size
    }

}
