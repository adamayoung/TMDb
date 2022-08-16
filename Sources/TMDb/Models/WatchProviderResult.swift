import Foundation

struct WatchProviderResult: Decodable, Equatable, Hashable {

    let results: [WatchProvider]

    init(results: [WatchProvider]) {
        self.results = results
    }

}
