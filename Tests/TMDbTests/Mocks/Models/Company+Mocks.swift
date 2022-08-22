import Foundation
import TMDb

extension Company {

    static func mock(
        id: Int = .randomID,
        name: String = .randomString,
        description: String = .randomString,
        headquarters: String = .randomString,
        homepage: URL = .randomWebSite,
        logoPath: URL = .randomImagePath,
        originCountry: String = "US",
        parentCompany: Company.Parent? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            description: description,
            headquarters: headquarters,
            homepage: homepage,
            logoPath: logoPath,
            originCountry: originCountry,
            parentCompany: parentCompany
        )
    }

    static var lucasfilm: Self {
        .mock(
            id: 1,
            name: "Lucasfilm Ltd.",
            description: "Some description",
            headquarters: "San Francisco, California",
            homepage: URL(string: "https://www.lucasfilm.com")!,
            logoPath: URL(string: "/o86DbpburjxrqAzEDhXZcyE8pDb.png")!,
            originCountry: "US"
        )
    }

}
