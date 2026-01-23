//
//  TMDbStatusResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct TMDbStatusResponse: Decodable, Sendable {

    let success: Bool
    let statusCode: Int
    let statusMessage: String

}
