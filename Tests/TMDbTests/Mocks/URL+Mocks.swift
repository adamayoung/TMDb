import Foundation

extension URL {

    static var randomImagePath: URL {
        URL(string: "/\(String.randomString).jpg")!
    }

    static var randomWebSite: URL {
        URL(string: "https://www.\(String.randomString).com")!
    }

    static func randomBaseURL(secure: Bool = true) -> URL {
        URL(string: "\(secure ? "https" : "http")://api.\(String.randomString).com/\(String.randomString)/")!
    }

}
