//
//  NetworkLogo+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension NetworkLogo {

    ///
    /// A sample network logo, for use in tests and previews.
    ///
    static var sample: NetworkLogo {
        NetworkLogo(
            filePath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png")
                ?? URL(fileURLWithPath: "/"),
            aspectRatio: 2.425287356321839
        )
    }

}

public extension [NetworkLogo] {

    ///
    /// A sample list of network logos, for use in tests and previews.
    ///
    static var samples: [NetworkLogo] {
        [.sample]
    }

}
