import Foundation

public struct CertificationsDTO: Decodable, Equatable {

    public let certifications: [String: [CertificationDTO]]

    public init(certifications: [String: [CertificationDTO]]) {
        self.certifications = certifications
    }

}
