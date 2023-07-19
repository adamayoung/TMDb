import Foundation

struct TMDbStatusResponse: Decodable {

    let success: Bool
    let statusCode: Int
    let statusMessage: String

}
