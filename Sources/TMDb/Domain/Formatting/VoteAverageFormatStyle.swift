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
/// rounded percentage string. The percent symbol and its placement are
/// determined by the provided `locale` via `.percent`, so the exact output
/// varies by locale (for example `"85%"` in English locales).
///
/// Use it directly:
///
/// ```swift
/// let style = VoteAverageFormatStyle()
/// style.format(8.5)
/// // "85%" in English locales
/// ```
///
/// Or via the `FormatStyle` convenience on `Double`:
///
/// ```swift
/// movie.voteAverage?.formatted(.voteAveragePercentage)
/// // "85%" in English locales
/// ```
///
public struct VoteAverageFormatStyle: FormatStyle, Codable, Equatable, Hashable, Sendable {

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
    /// resulting percentage is rounded to the nearest whole number. Non-finite
    /// values are handled gracefully: `nan` is treated as zero, while positive
    /// and negative infinity clamp to the upper and lower bounds respectively.
    ///
    /// - Parameter value: The vote average, on a scale from `0` to `10`.
    ///
    /// - Returns: A percentage string, for example `"85%"` in English locales.
    ///
    public func format(_ value: Double) -> String {
        let sanitised = value.isNaN ? 0 : value
        let clamped = min(max(sanitised, 0), 10)
        let percent = Int((clamped * 10).rounded())
        return percent.formatted(.percent.locale(locale))
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
    /// // "85%" in English locales
    /// ```
    ///
    static var voteAveragePercentage: VoteAverageFormatStyle {
        VoteAverageFormatStyle()
    }

}
