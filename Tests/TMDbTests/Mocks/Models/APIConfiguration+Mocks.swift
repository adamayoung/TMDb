import Foundation
import TMDb

extension APIConfiguration {

    static var mock: Self {
        .init(
            images: .mock,
            changeKeys: [
                "air_date",
                "also_known_as"
            ]
        )
    }

}
