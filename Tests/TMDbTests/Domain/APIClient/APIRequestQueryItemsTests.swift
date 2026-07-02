//
//  APIRequestQueryItemsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.apiClient, .domain))
struct APIRequestQueryItemsTests {

    @Test("subscript(ifPresent:) sets the key when the value is present")
    func ifPresentSubscriptSetsPresentValue() {
        var queryItems = APIRequestQueryItems()
        let page: Int? = 3

        queryItems[ifPresent: .page] = page

        #expect(queryItems.count == 1)
        #expect(queryItems[.page]?.description == "3")
    }

    @Test("subscript(ifPresent:) is a no-op when the value is nil")
    func ifPresentSubscriptIgnoresNilValue() {
        var queryItems = APIRequestQueryItems()
        let page: Int? = nil

        queryItems[ifPresent: .page] = page

        #expect(queryItems.isEmpty)
    }

    @Test("subscript(ifPresent:) does not clear an existing value when set to nil")
    func ifPresentSubscriptDoesNotClearExistingValue() {
        var queryItems = APIRequestQueryItems()
        queryItems[ifPresent: .page] = 3
        let missing: Int? = nil

        queryItems[ifPresent: .page] = missing

        #expect(queryItems[.page]?.description == "3")
    }

    @Test("subscript(ifPresent:) getter returns the stored value")
    func ifPresentSubscriptGetterReturnsStoredValue() {
        var queryItems = APIRequestQueryItems()
        queryItems[.language] = "en"

        #expect(queryItems[ifPresent: .language]?.description == "en")
    }

}
