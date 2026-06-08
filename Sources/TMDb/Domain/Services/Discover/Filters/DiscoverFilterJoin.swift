//
//  DiscoverFilterJoin.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

///
/// A logical operator describing how multiple values of a discover filter
/// parameter are combined.
///
/// The TMDb API joins multi-valued parameters such as genres and keywords
/// using either a comma (logical AND — results must match **all** values) or
/// a pipe (logical OR — results must match **any** value).
///
public enum DiscoverFilterJoin: Equatable, Hashable, Sendable {

    ///
    /// Match results that satisfy **all** of the supplied values.
    ///
    /// Values are joined with a comma (`,`) in the request.
    ///
    case and

    ///
    /// Match results that satisfy **any** of the supplied values.
    ///
    /// Values are joined with a pipe (`|`) in the request.
    ///
    case or

    ///
    /// The separator used to join values in the request query.
    ///
    public var separator: String {
        switch self {
        case .and: ","
        case .or: "|"
        }
    }

    ///
    /// Joins a list of identifiers into a query value using this operator.
    ///
    /// - Parameter ids: The identifiers to join.
    ///
    /// - Returns: The identifiers joined with this operator's separator.
    ///
    public func queryValue(for ids: [Int]) -> String {
        ids.map(\.description).joined(separator: separator)
    }

}
