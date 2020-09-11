import Foundation

public struct Certifications: Decodable, Equatable {

    public let certifications: [String: [Certification]]

    public init(certifications: [String : [Certification]]) {
        self.certifications = certifications
    }

}
