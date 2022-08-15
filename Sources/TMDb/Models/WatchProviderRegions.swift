import Foundation

struct WatchProviderRegions: Decodable, Equatable, Hashable {

    let results: [Country]

    init(results: [Country]) {
        self.results = results
    }

}
