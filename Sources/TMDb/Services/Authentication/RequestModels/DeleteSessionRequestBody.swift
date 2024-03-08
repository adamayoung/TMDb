import Foundation

struct DeleteSessionRequestBody: Encodable, Equatable {

    let sessionID: String

}

extension DeleteSessionRequestBody {

    private enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
    }

}
