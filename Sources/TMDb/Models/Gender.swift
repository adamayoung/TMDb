import Foundation

/// Gender of a person.
public enum Gender: Int, Decodable, Equatable, Hashable {

    /// Unknown.
    case unknown = 0
    /// Female.
    case female = 1
    /// Male.
    case male = 2
    /// Other.
    case other = 3

    public init(from decoder: Decoder) throws {
        self = try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
