//
//  WatchProvider+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension WatchProvider {

    static func mock(
        id: Int = 1,
        name: String = "Netflix",
        logoPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        displayPriority: Int? = 0
    ) -> WatchProvider {
        WatchProvider(
            id: id,
            name: name,
            logoPath: logoPath,
            displayPriority: displayPriority
        )
    }

    static var netflix: WatchProvider {
        WatchProvider.mock(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
        )
    }

}
