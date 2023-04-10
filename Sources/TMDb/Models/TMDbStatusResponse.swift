import Foundation

struct TMDbStatusResponse: Decodable {

    let success: Bool
    let statusCode: Int
    let statusMessage: String

    init(success: Bool, statusCode: Int, statusMessage: String) {
        self.success = success
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }

}
