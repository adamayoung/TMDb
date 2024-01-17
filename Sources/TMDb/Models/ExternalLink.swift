//
//  ExternalLink.swift
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
/// An interface for an external link.
///
/// e.g. to a Movie's IMDb page.
///
public protocol ExternalLink: Equatable, Hashable {

    ///
    /// The external site's item identifier.
    ///
    var id: String { get }

    ///
    /// The URL of the external site's item page.
    ///
    var url: URL { get }

}
