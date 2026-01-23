//
//  ShowCastCredit+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension ShowCastCredit {

    static var movieMock: ShowCastCredit {
        .movie(.mock())
    }

    static var tvSeriesMock: ShowCastCredit {
        .tvSeries(.mock())
    }

}

extension [ShowCastCredit] {

    static var mocks: [ShowCastCredit] {
        [
            .movie(.mock(id: 1)),
            .tvSeries(.mock(id: 2)),
            .movie(.mock(id: 3))
        ]
    }

}
