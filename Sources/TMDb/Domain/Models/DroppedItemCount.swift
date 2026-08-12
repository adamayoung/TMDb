//
//  DroppedItemCount.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// How many elements a tolerant container skipped while decoding.
///
/// This is decode **telemetry**, not part of a model's value. Two otherwise-identical
/// models are equal whether or not either skipped an element, and the count is absent
/// from every `CodingKeys`, so `Equatable`, `Hashable` and `Codable` all agree on what
/// a value *is*: exactly its public content. Without that, a decoded page that skipped
/// an element would not equal its own encode-decode round trip, and a consumer using a
/// page as a dictionary key or diffing one across a cache boundary would see a
/// mismatch with no visible cause — the differing field not even being visible to them.
///
/// Wrapping the count in a type whose `==` is always `true` keeps that guarantee in one
/// documented place, so the containing models keep their **synthesized** conformances.
/// The alternative — hand-writing `==` and `hash(into:)` on each of them — puts the
/// same claim in five places and silently goes wrong the day someone adds a property
/// and forgets one.
///
package struct DroppedItemCount: Equatable, Hashable {

    ///
    /// The number of elements skipped.
    ///
    package let value: Int

    ///
    /// No elements were skipped.
    ///
    package static let none = DroppedItemCount(0)

    ///
    /// Creates a dropped item count.
    ///
    /// - Parameter value: The number of elements skipped.
    ///
    package init(_ value: Int) {
        self.value = value
    }

    ///
    /// Returns `true` — always.
    ///
    /// Telemetry is deliberately excluded from a model's identity; see the type's
    /// documentation.
    ///
    /// - Parameters:
    ///    - lhs: A value to compare.
    ///    - rhs: Another value to compare.
    ///
    /// - Returns: `true`.
    ///
    package static func == (lhs: DroppedItemCount, rhs: DroppedItemCount) -> Bool {
        true
    }

    ///
    /// Contributes nothing to the hasher, matching ``==(_:_:)``.
    ///
    /// - Parameter hasher: The hasher to use.
    ///
    package func hash(into hasher: inout Hasher) {}

}
