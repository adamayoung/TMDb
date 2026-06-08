//
//  VoteAverageFormatStyle.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A format style that renders a TMDb vote average as a percentage.
///
/// TMDb expresses vote averages as a `Double` on a scale from `0` to `10` (for
/// example ``Movie/voteAverage``). This format style converts that score into a
/// rounded, localized percentage string.
///
/// Use it directly:
///
/// ```swift
/// let style = VoteAverageFormatStyle()
/// style.format(8.5)
/// // "85%"
/// ```
///
/// Or via the ``Foundation/FormatStyle`` convenience on `Double`:
///
/// ```swift
/// movie.voteAverage?.formatted(.voteAveragePercentage)
/// // "85%"
/// ```
///
public struct VoteAverageFormatStyle: FormatStyle {

    ///
    /// The vote average, on a scale from `0` to `10`, to be formatted.
    ///
    public typealias FormatInput = Double

    ///
    /// The formatted percentage string.
    ///
    public typealias FormatOutput = String

    ///
    /// The locale used when formatting the percentage.
    ///
    public var locale: Locale

    ///
    /// Creates a vote average format style.
    ///
    /// - Parameter locale: The locale used when formatting. Defaults to
    ///   `.autoupdatingCurrent`.
    ///
    public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }

    ///
    /// Formats a vote average as a rounded percentage string.
    ///
    /// The score is clamped to the range `0...10` before conversion, and the
    /// resulting percentage is rounded to the nearest whole number.
    ///
    /// - Parameter value: The vote average, on a scale from `0` to `10`.
    ///
    /// - Returns: A localized percentage string, for example `"85%"`.
    ///
    public func format(_ value: Double) -> String {
        let clamped = min(max(value, 0), 10)
        let percent = Int((clamped * 10).rounded())
        return percent.formatted(.percent.scale(1).locale(locale))
    }

    ///
    /// Returns a copy of this format style using the given locale.
    ///
    /// - Parameter locale: The locale to apply.
    ///
    /// - Returns: A copy of the format style with the given locale.
    ///
    public func locale(_ locale: Locale) -> VoteAverageFormatStyle {
        VoteAverageFormatStyle(locale: locale)
    }

}

public extension FormatStyle where Self == VoteAverageFormatStyle {

    ///
    /// A vote average format style for use with `Double.formatted(_:)`.
    ///
    /// ```swift
    /// movie.voteAverage?.formatted(.voteAveragePercentage)
    /// // "85%"
    /// ```
    ///
    static var voteAveragePercentage: VoteAverageFormatStyle {
        VoteAverageFormatStyle()
    }

}
