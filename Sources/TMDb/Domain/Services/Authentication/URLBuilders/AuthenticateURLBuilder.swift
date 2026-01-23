//
//  AuthenticateURLBuilder.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AuthenticateURLBuilder: AuthenticateURLBuilding {

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func authenticateURL(with requestToken: String) -> URL {
        authenticateURL(with: requestToken, redirectURL: nil)
    }

    func authenticateURL(with requestToken: String, redirectURL: URL?) -> URL {
        let url =
            baseURL
                .appendingPathComponent("authenticate")
                .appendingPathComponent(requestToken)

        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }

        var queryItems = urlComponents.queryItems ?? []
        if let redirectURL {
            let queryItem = URLQueryItem(name: "redirect_to", value: redirectURL.absoluteString)
            queryItems.append(queryItem)
        }

        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        return urlComponents.url ?? url
    }

}
