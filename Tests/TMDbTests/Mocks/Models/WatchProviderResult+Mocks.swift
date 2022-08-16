import Foundation
@testable import TMDb

extension WatchProviderResult {

    static var mock: Self {
        .init(
            results: [
                .init(id: 8, name: "Netflix", logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!),
                .init(id: 9, name: "Amazon Prime Video", logoPath: URL(string: "/emthp39XA2YScoYL1p0sdbAH2WA.jpg")!)
            ]
        )
    }

}
