import Foundation
import TMDb

extension CastMember {

    static var mock: Self {
        let id = Int.randomID

        return .init(
            id: id,
            castID: .randomID,
            creditID: .randomID,
            name: "Cast \(id)",
            character: "Character 1",
            order: 1
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
