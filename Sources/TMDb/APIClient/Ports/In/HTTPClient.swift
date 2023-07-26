import Foundation

public protocol HTTPClient {

    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse

}
