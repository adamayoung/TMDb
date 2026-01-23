//
//  Certification+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Certification {

    static func mock(
        code: String = "U",
        meaning: String = "All ages admitted, there is nothing unsuitable for children.",
        order: Int = 1
    ) -> Certification {
        Certification(
            code: code,
            meaning: meaning,
            order: order
        )
    }

    static var gbU: Certification {
        Certification.mock(
            code: "U",
            meaning: "All ages admitted, there is nothing unsuitable for children.",
            order: 1
        )
    }

    static var gbPG: Certification {
        Certification.mock(
            code: "PG",
            meaning: """
            All ages admitted, but certain scenes may be unsuitable for young children. May contain mild \
            language and sex/drugs references. May contain moderate violence if justified by context \
            (e.g. fantasy).
            """,
            order: 2
        )
    }

    static var gb12A: Certification {
        Certification.mock(
            code: "12A",
            meaning: """
            Films under this category are considered to be unsuitable for very young people. Those aged \
            under 12 years are only admitted if accompanied by an adult, aged at least 18 years, at all times \
            during the motion picture. However, it is generally not recommended that children under 12 years should \
            watch the film. Films under this category can contain mature themes, discrimination, soft drugs, \
            moderate swear words, infrequent strong language and moderate violence, sex references and nudity. \
            Sexual activity may be briefly and discreetly portrayed. Sexual violence may be implied or briefly \
            indicated.
            """,
            order: 2
        )
    }

    static var usG: Certification {
        Certification.mock(
            code: "G",
            meaning: """
            All ages admitted. There is no content that would be objectionable to most parents. This is one \
            of only two ratings dating back to 1968 that still exists today.
            """,
            order: 1
        )
    }

    static var usPG13: Certification {
        Certification.mock(
            code: "PG-13",
            meaning: """
            Some material may be inappropriate for children under 13. Films given this rating may contain \
            sexual content, brief or partial nudity, some strong language and innuendo, humor, mature themes, \
            political themes, terror and/or intense action violence. However, bloodshed is rarely present. This is \
            the minimum rating at which drug content is present.
            """,
            order: 2
        )
    }

}
