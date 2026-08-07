//
//  HTTPRequest+StateChanging.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension HTTPRequest {

    ///
    /// Whether this `GET` mutates server state despite its method.
    ///
    /// `GET /4/list/{id}/clear` empties a list — `POST` to that path returns
    /// 404 — so its method says "safe and repeatable" while its effect says
    /// otherwise. v3's clear is a `POST` and never matches.
    ///
    /// Both decorators need this and must agree, which is why it lives here
    /// rather than in either of them: `CacheHTTPClient` has to invalidate
    /// instead of caching, and `RetryHTTPClient` must not replay it. Splitting
    /// the judgement across the two is how they would drift apart.
    ///
    var isStateChangingGET: Bool {
        method == .get && url.path.hasSuffix("/clear")
    }

}
