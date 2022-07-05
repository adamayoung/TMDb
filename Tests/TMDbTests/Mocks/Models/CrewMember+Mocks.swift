import Foundation
import TMDb

extension CrewMember {

    static var mock: Self {
        let id = Int.randomID

        return .init(
            id: id,
            creditID: .randomID,
            name: "Crew \(id)",
            job: "Job \(String.randomString)",
            department: "Department \(String.randomString))"
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
