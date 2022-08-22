import Foundation
import TMDb

extension SpokenLanguage {

    static func mocks(
        languageCode: String = .randomString,
        name: String = .randomString
    ) -> Self {
        .init(
            languageCode: languageCode,
            name: name
        )
    }

}

extension Array where Element == SpokenLanguage {

    static var mocks: [Element] {
        [.mocks(), .mocks(), .mocks()]
    }

}
