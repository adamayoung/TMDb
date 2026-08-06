//
//  V4AuthenticateURLBuilder.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class V4AuthenticateURLBuilder: V4AuthenticateURLBuilding {

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func authenticateURL(with requestToken: String) -> URL {
        authenticateURL(with: requestToken, redirectURL: nil)
    }

    func authenticateURL(with requestToken: String, redirectURL: URL?) -> URL {
        // Unlike the v3 approval URL, which carries the token as a path
        // component, v4 expects it as a query item on /auth/access.
        let url = baseURL.appendingPathComponent("auth").appendingPathComponent("access")

        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }

        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "request_token", value: requestToken))

        if let redirectURL {
            let queryItem = URLQueryItem(name: "redirect_to", value: redirectURL.absoluteString)
            queryItems.append(queryItem)
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url ?? url
    }

}
