//
//  NetworkLogo.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV network logo.
///
public struct NetworkLogo: Codable, Equatable, Hashable, Sendable {

    ///
    /// The file path for the logo image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let filePath: URL

    ///
    /// The aspect ratio of the logo image.
    ///
    public let aspectRatio: Double

    ///
    /// Creates a TV network logo.
    ///
    /// - Parameters:
    ///    - filePath: The file path for the logo image.
    ///    - aspectRatio: The aspect ratio of the logo image.
    ///
    public init(filePath: URL, aspectRatio: Double) {
        self.filePath = filePath
        self.aspectRatio = aspectRatio
    }

}
