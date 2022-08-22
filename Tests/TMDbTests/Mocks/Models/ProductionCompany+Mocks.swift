import Foundation
import TMDb

extension ProductionCompany {

    static func mock(
        id: Int = .randomID,
        name: String? = nil,
        originCountry: String = .randomString,
        logoPath: URL? = .randomImagePath
    ) -> Self {
        .init(
            id: id,
            name: name ?? "Production Company \(id)",
            originCountry: originCountry,
            logoPath: logoPath
        )
    }

}

extension Array where Element == ProductionCompany {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
