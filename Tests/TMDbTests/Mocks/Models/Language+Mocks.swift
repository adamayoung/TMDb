import Foundation
import TMDb

extension Language {

    static var mocks: [Self] {
        [
            .init(code: "af", name: "Afrikaans", englishName: "Afrikaans"),
            .init(code: "hu", name: "Magyar", englishName: "Hungarian"),
            .init(code: "ga", name: "Gaeilge", englishName: "Irish"),
            .init(code: "en", name: "English", englishName: "English")
        ]
    }

}
