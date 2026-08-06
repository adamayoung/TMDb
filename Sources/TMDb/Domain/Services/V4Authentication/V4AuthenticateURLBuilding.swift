//
//  V4AuthenticateURLBuilding.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

protocol V4AuthenticateURLBuilding: Sendable {

    func authenticateURL(with requestToken: String) -> URL

    func authenticateURL(with requestToken: String, redirectURL: URL?) -> URL

}
