import Foundation
import TMDb

extension ImagesConfiguration {

    static var mock: Self {
        .init(
            baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
            secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
            backdropSizes: [
                "w300"
            ],
            logoSizes: [
                "w45"
            ],
            posterSizes: [
                "w92"
            ],
            profileSizes: [
                "w45"
            ],
            stillSizes: [
                "w92"
            ]
        )
    }

}
