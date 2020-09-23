import Foundation

public struct CertificationDTO: Identifiable, Decodable, Equatable {

    public var id: String {
        code
    }

    public let code: String
    public let meaning: String
    public let order: Int

}

extension CertificationDTO {

    private enum CodingKeys: String, CodingKey {
        case code = "certification"
        case meaning
        case order
    }

}
