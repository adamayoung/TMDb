//
//  MediaListItemStatus+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension MediaListItemStatus {

    static func mock(
        id: String = "1",
        isPresent: Bool = false
    ) -> MediaListItemStatus {
        MediaListItemStatus(
            id: id,
            isPresent: isPresent
        )
    }

}
