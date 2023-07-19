import Foundation

///
/// A model representing a list of officially supported certifications for movies or TV shows.
///
public struct Certifications: Codable, Equatable, Hashable {

    ///
    /// Certifications for each country.
    ///
    public let certifications: [String: [Certification]]

    ///
    /// Creates a certifications object.
    ///
    /// - Parameters:
    ///    - certifications: Certifications for each country.
    /// 
    public init(certifications: [String: [Certification]]) {
        self.certifications = certifications
    }

}
