import Foundation

/// Officially supported certification.
public struct Certification: Identifiable, Decodable, Equatable, Hashable {

    public var id: String { code }
    /// Certification code.
    public let code: String
    /// Certification meaning.
    public let meaning: String
    /// Order number of certification in list.
    public let order: Int

    /// Creates a new `Certification`.
    ///
    /// - Parameters:
    ///    - code: Certification code.
    ///    - meaning: Certification meaning.
    ///    - order: Order number of certification in list.
    public init(code: String, meaning: String, order: Int) {
        self.code = code
        self.meaning = meaning
        self.order = order
    }

}

extension Certification {

    private enum CodingKeys: String, CodingKey {
        case code = "certification"
        case meaning
        case order
    }

}
