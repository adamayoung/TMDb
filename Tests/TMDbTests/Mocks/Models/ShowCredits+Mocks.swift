import Foundation
import TMDb

extension ShowCredits {

    static var mock: Self {
        return .init(
            id: .randomID,
            cast: CastMember.mocks,
            crew: CrewMember.mocks
        )
    }

}
