//
//  Certification+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Certification {

    /// A sample `Certification` for use in tests and previews.
    static var sample: Certification {
        Certification(
            code: "U",
            meaning: "All ages admitted, there is nothing unsuitable for children.",
            order: 1
        )
    }

}

public extension [Certification] {

    /// A sample array of `Certification` values for use in tests and previews.
    static var samples: [Certification] {
        [
            Certification(
                code: "U",
                meaning: "All ages admitted, there is nothing unsuitable for children.",
                order: 1
            ),
            Certification(
                code: "PG",
                meaning: """
                All ages admitted, but certain scenes may be unsuitable for young children. May contain \
                mild language and sex/drugs references. May contain moderate violence if justified by \
                context (e.g. fantasy).
                """,
                order: 2
            )
        ]
    }

}
