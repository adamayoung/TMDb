//
//  File.swift
//  
//
//  Created by Adam Young on 15/05/2024.
//

import Foundation

///
/// An interface to provide configuration for service.
///
/// Create an API key at [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).
///
public protocol ConfigurationProviding {

    ///
    /// TMDb API key.
    ///
    var apiKey: String { get }

    ///
    /// The HTTP client adapter for making HTTP requests.
    ///
    var httpClient: any HTTPClient { get }

}
