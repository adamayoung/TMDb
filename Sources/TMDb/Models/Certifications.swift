import Foundation

/// A list of officially supported certifications for movies or TV shows.
public struct Certifications: Decodable, Equatable {

    /// Certifications for each country.
    public let certifications: [String: [Certification]]

    /// Creates a new `Certifications`.
    ///
    /// - Parameters:
    ///    - certifications: Certifications for each country.
    public init(certifications: [String: [Certification]]) {
        self.certifications = certifications
    }

}
