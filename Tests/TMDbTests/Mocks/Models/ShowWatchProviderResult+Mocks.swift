import Foundation
@testable import TMDb

extension ShowWatchProviderResult {

    static func mock(
        id: Int = .randomID,
        regionCode: String = "GB"
    ) -> Self {
        .init(
            id: id,
            results: [regionCode: .mock()]
        )
    }
}
