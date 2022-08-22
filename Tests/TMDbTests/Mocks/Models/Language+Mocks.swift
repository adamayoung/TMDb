import Foundation
import TMDb

extension Language {

    static func mock(
        code: String = "en",
        name: String = .randomString,
        englishName: String = .randomString
    ) -> Self {
        .init(
            code: code,
            name: name,
            englishName: englishName
        )
    }

    static var african: Self {
        .mock(code: "af", name: "Afrikaans", englishName: "Afrikaans")
    }

    static var hungarian: Self {
        .mock(code: "hu", name: "Magyar", englishName: "Hungarian")
    }

    static var irish: Self {
        .mock(code: "ga", name: "Gaeilge", englishName: "Irish")
    }

    static var english: Self {
        .mock(code: "en", name: "English", englishName: "English")
    }

}


extension Array where Element == Language {

    static var mocks: [Language] {
        [.african, .hungarian, .irish, .english]
    }

}
