import Foundation
import TMDb

extension Company {

    static var mock: Self {
        .init(
            id: 1,
            name: "Lucasfilm Ltd.",
            description: "",
            headquarters: "San Francisco, California",
            homepage: URL(string: "https://www.lucasfilm.com")!,
            logoPath: URL(string: "/o86DbpburjxrqAzEDhXZcyE8pDb.png")!,
            originCountry: "US",
            parentCompany: nil
        )
    }

}
