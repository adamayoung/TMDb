import Foundation
import TMDb

extension Country {

    static func mock(
        countryCode: String = "US",
        name: String = .randomString,
        englishName: String = .randomString
    ) -> Self {
        .init(
            countryCode: countryCode,
            name: name,
            englishName: englishName
        )
    }

    static var unitedKingdom: Self {
        .mock(countryCode: "GB", name: "United Kingdom", englishName: "United Kingdom")
    }

    static var unitedStates: Self {
        .mock(countryCode: "US", name: "United States", englishName: "United States of America")
    }

}

extension Array where Element == Country {

    static var mocks: [Element] {
        [.unitedKingdom, .unitedStates]
    }

}
