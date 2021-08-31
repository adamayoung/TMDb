import Foundation

/// Show status.
public enum Status: String, Decodable, Equatable, Hashable {

    /// Rumoured.
    case rumoured = "Rumored"
    // Planned.
    case planned = "Planned"
    /// In production.
    case inProduction = "In Production"
    /// Post production.
    case postProduction = "Post Production"
    /// Released.
    case released = "Released"
    /// Cancelled.
    case cancelled = "Canceled"

}
