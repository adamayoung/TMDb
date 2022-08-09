import Foundation

extension URLSessionConfiguration {

    static var integrationTest: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [TMDbURLProtocol.self]
        return configuration
    }

}
