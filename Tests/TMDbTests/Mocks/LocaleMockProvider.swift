import Foundation
@testable import TMDb

final class LocaleMockProvider: LocaleProviding {

    var languageCode: String?
    
    var regionCode: String?

    init(languageCode: String? = nil, regionCode: String? = nil) {
        self.languageCode = languageCode
        self.regionCode = regionCode
    }

}
