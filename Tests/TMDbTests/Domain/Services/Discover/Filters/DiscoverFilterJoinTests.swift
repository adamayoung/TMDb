//
//  DiscoverFilterJoinTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverFilterJoinTests {

    @Test("and separator is comma")
    func andSeparatorIsComma() {
        #expect(DiscoverFilterJoin.and.separator == ",")
    }

    @Test("or separator is pipe")
    func orSeparatorIsPipe() {
        #expect(DiscoverFilterJoin.or.separator == "|")
    }

    @Test("and joins identifiers with comma")
    func andJoinsIdentifiersWithComma() {
        let value = DiscoverFilterJoin.and.queryValue(for: [1, 2, 3])

        #expect(value == "1,2,3")
    }

    @Test("or joins identifiers with pipe")
    func orJoinsIdentifiersWithPipe() {
        let value = DiscoverFilterJoin.or.queryValue(for: [1, 2, 3])

        #expect(value == "1|2|3")
    }

}
