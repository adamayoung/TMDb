import Foundation

///
/// A model representing an officially supported certification.
///
public struct Certification: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Certification's identifier (same as ``code``).
    ///
    public var id: String { code }

    ///
    /// Certification code.
    ///
    public let code: String

    ///
    /// Certification meaning.
    ///
    public let meaning: String

    ///
    /// Order number of certification in list.
    /// 
    public let order: Int

    ///
    /// Creates a certification object.
    ///
    /// - Parameters:
    ///    - code: Certification code.
    ///    - meaning: Certification meaning.
    ///    - order: Order number of certification in list.
    ///
    public init(
        code: String,
        meaning: String,
        order: Int
    ) {
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
