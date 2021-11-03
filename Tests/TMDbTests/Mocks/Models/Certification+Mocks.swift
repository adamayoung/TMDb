import Foundation
import TMDb

extension Certification {

    static var mocks: [String: [Certification]] {
        [
            "1": [
                Certification(code: UUID().uuidString, meaning: "Meaning \(String.randomID)", order: 1),
                Certification(code: UUID().uuidString, meaning: "Meaning \(String.randomID)", order: 2),
                Certification(code: UUID().uuidString, meaning: "Meaning \(String.randomID)", order: 3)
            ],
            "2": [
                Certification(code: UUID().uuidString, meaning: "Meaning \(String.randomID)", order: 1),
                Certification(code: UUID().uuidString, meaning: "Meaning \(String.randomID)", order: 2)
            ]
        ]
    }

}
