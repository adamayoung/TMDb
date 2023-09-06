import Foundation
import TMDb

extension Media {

    static func mock() -> Self {
        .movie(.topGunMaverick)
    }

}

extension Array where Element == Media {

    static var mocks: [Element] {
        [
            .movie(.bulletTrain),
            .movie(.topGunMaverick),
            .tvSeries(.strangerThings),
            .tvSeries(.theSandman),
            .movie(.jurassicWorldDominion),
            .tvSeries(.sheHulk)
        ]
    }

}
