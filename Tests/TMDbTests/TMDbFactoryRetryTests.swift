//
//  TMDbFactoryRetryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct TMDbFactoryRetryTests {

    @Test("httpClient with nil retryConfiguration returns original client")
    func httpClientWithNilRetryConfigurationReturnsOriginal() {
        let mockClient = SequencingHTTPMockClient()

        let result = TMDbFactory.httpClient(wrapping: mockClient, retryConfiguration: nil)

        #expect(result is SequencingHTTPMockClient)
    }

    @Test("httpClient with retryConfiguration returns RetryHTTPClient")
    func httpClientWithRetryConfigurationReturnsRetryClient() {
        let mockClient = SequencingHTTPMockClient()
        let config = RetryConfiguration.default

        let result = TMDbFactory.httpClient(wrapping: mockClient, retryConfiguration: config)

        #expect(result is RetryHTTPClient)
    }

}
