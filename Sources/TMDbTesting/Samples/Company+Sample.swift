//
//  Company+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Company {

    /// A sample `Company` populated with representative data.
    static var sample: Company {
        Company(
            id: 1,
            name: "Lucasfilm Ltd.",
            description: "",
            headquarters: "San Francisco, California",
            homepageURL: URL(string: "https://www.lucasfilm.com"),
            logoPath: URL(string: "/tlVSws0RvvtPBwViUyOFAO0vcQS.png")
                ?? URL(fileURLWithPath: "/"),
            originCountry: "US",
            parentCompany: nil
        )
    }

}
