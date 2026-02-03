//
//  ShowCrewCredit+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension ShowCrewCredit {

    static var movieMock: ShowCrewCredit {
        .movie(.mock())
    }

    static var tvSeriesMock: ShowCrewCredit {
        .tvSeries(.mock())
    }

}

extension [ShowCrewCredit] {

    static var mocks: [ShowCrewCredit] {
        [
            .movie(.mock(id: 1)),
            .tvSeries(.mock(id: 2)),
            .movie(.mock(id: 3))
        ]
    }

}
