//
//  NetworkLogo+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension NetworkLogo {

    // swift-format-ignore: NeverForceUnwrap
    static func mock(
        filePath: URL = URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png")!,
        aspectRatio: Double = 2.425287356321839
    ) -> NetworkLogo {
        NetworkLogo(
            filePath: filePath,
            aspectRatio: aspectRatio
        )
    }

}
