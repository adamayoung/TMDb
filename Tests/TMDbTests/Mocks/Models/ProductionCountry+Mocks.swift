import Foundation
import TMDb

extension ProductionCountry {

    static func mock(
        countryCode: String = .randomString,
        name: String = .randomString
    ) -> Self {
        .init(
            countryCode: countryCode,
            name: name
        )
    }

}

extension Array where Element == ProductionCountry {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
