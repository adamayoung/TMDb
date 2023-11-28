//
//  VideoSize.swift
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
/// A model representing a video size.
///
public enum VideoSize: Int, Codable, Equatable, Hashable {

    ///
    /// 360.
    ///
    case s360 = 360

    ///
    /// 480.
    ///
    case s480 = 480

    ///
    /// 720.
    ///
    case s720 = 720

    ///
    /// 1080.
    ///
    case s1080 = 1080

    ///
    /// Unknown.
    ///
    case unknown

    public init(from decoder: Decoder) throws {
        self = try VideoSize(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
