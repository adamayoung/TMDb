//
//  EndpointPathRedactorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.networking))
struct EndpointPathRedactorTests {

    @Test("redacts the guest session id segment")
    func redactsGuestSessionIDSegment() {
        let redacted = EndpointPathRedactor.redact("/guest_session/abc123secret/rated/movies")

        #expect(redacted == "/guest_session/{guest_session_id}/rated/movies")
        #expect(!redacted.contains("abc123secret"))
    }

    @Test("redacts the account id segment")
    func redactsAccountIDSegment() {
        let redacted = EndpointPathRedactor.redact("/account/12345/favorite")

        #expect(redacted == "/account/{account_id}/favorite")
    }

    @Test("redacts a trailing account id segment")
    func redactsTrailingAccountIDSegment() {
        let redacted = EndpointPathRedactor.redact("/account/12345")

        #expect(redacted == "/account/{account_id}")
    }

    @Test("does not redact the guest session creation path")
    func doesNotRedactGuestSessionCreationPath() {
        let redacted = EndpointPathRedactor.redact("/authentication/guest_session/new")

        #expect(redacted == "/authentication/guest_session/new")
    }

    @Test("leaves an unrelated path unchanged")
    func leavesUnrelatedPathUnchanged() {
        let redacted = EndpointPathRedactor.redact("/movie/550")

        #expect(redacted == "/movie/550")
    }

    @Test("leaves a path with fewer than two segments unchanged", arguments: ["/account", "/", ""])
    func leavesShortPathUnchanged(path: String) {
        #expect(EndpointPathRedactor.redact(path) == path)
    }

}
