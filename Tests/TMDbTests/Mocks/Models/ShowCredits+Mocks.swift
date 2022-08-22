import Foundation
import TMDb

extension ShowCredits {

    static func mock(
        id: Int = .randomID,
        cast: [CastMember] = .mocks,
        crew: [CrewMember] = .mocks
    ) -> Self {
        .init(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
