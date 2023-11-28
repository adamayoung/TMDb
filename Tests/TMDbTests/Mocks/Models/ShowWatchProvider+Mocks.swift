import Foundation
@testable import TMDb

extension ShowWatchProvider {

    static func mock(
        link: String = "",
        free: [WatchProvider]? = [.netflix],
        flatrate: [WatchProvider]? = [.netflix],
        buy: [WatchProvider]? = [.netflix],
        rent: [WatchProvider]? = [.netflix]
    ) -> Self {
        .init(
            link: link,
            free: free,
            flatrate: flatrate,
            buy: buy,
            rent: rent
        )
    }
}
