import Foundation

final class LocaleProvider: LocaleProviding {

    var languageCode: String? {
        #if os(Linux)
        locale.languageCode
        #else
        if #available(macOS 13.0, *) {
            locale.language.languageCode?.identifier
        } else {
            locale.languageCode
        }
        #endif
    }

    var regionCode: String? {
        #if os(Linux)
        locale.regionCode
        #else
        if #available(macOS 13.0, *) {
            locale.region?.identifier
        } else {
            locale.regionCode
        }
        #endif
    }

    private let locale: Locale

    init(locale: Locale = .current) {
        self.locale = locale
    }

}
