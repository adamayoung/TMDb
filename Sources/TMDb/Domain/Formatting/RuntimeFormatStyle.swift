//
//  RuntimeFormatStyle.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A format style that renders a runtime, given in whole minutes, as a
/// human-readable string.
///
/// TMDb exposes movie and television episode runtimes as an integer number of
/// minutes (for example ``Movie/runtime`` and ``TVEpisode/runtime``). This
/// format style turns that integer into a localized, display-ready string.
///
/// Use it directly:
///
/// ```swift
/// let style = RuntimeFormatStyle(style: .abbreviated, displayUnit: .hourMinute)
/// style.format(135)
/// // "2h 15m"
/// ```
///
/// Or via the ``Foundation/FormatStyle`` convenience on `Int`:
///
/// ```swift
/// movie.runtime?.formatted(.runtimeStyle(.full, displayUnit: .hourMinute))
/// // "2 hours, 15 minutes"
///
/// movie.runtime?.formatted(.runtimeStyle(.abbreviated, displayUnit: .minutesOnly))
/// // "139 min"
/// ```
///
public struct RuntimeFormatStyle: FormatStyle {

    ///
    /// The runtime, in minutes, to be formatted.
    ///
    public typealias FormatInput = Int

    ///
    /// The formatted, human-readable runtime string.
    ///
    public typealias FormatOutput = String

    ///
    /// The level of abbreviation applied to the formatted units.
    ///
    public enum Style: String, Codable, Hashable, Sendable {

        ///
        /// Abbreviated units, for example `"2h 15m"` or `"139 min"`.
        ///
        case abbreviated

        ///
        /// Full, spelled-out units, for example `"2 hours, 15 minutes"`.
        ///
        case full
    }

    ///
    /// The units used to express a runtime.
    ///
    public enum DisplayUnit: String, Codable, Hashable, Sendable {

        ///
        /// Express the runtime as hours and minutes.
        ///
        /// The hours component is omitted when the runtime is under one hour,
        /// and the minutes component is omitted when the runtime is an exact
        /// number of hours.
        ///
        case hourMinute

        ///
        /// Express the runtime as a total number of minutes.
        ///
        case minutesOnly
    }

    ///
    /// The level of abbreviation applied to the formatted units.
    ///
    public let style: Style

    ///
    /// The units used to express the runtime.
    ///
    public let displayUnit: DisplayUnit

    ///
    /// The locale used when formatting numbers and unit labels.
    ///
    public var locale: Locale

    ///
    /// Creates a runtime format style.
    ///
    /// - Parameters:
    ///   - style: The level of abbreviation applied to the formatted units.
    ///     Defaults to ``Style/abbreviated``.
    ///   - displayUnit: The units used to express the runtime. Defaults to
    ///     ``DisplayUnit/hourMinute``.
    ///   - locale: The locale used when formatting. Defaults to
    ///     `.autoupdatingCurrent`.
    ///
    public init(
        style: Style = .abbreviated,
        displayUnit: DisplayUnit = .hourMinute,
        locale: Locale = .autoupdatingCurrent
    ) {
        self.style = style
        self.displayUnit = displayUnit
        self.locale = locale
    }

    ///
    /// Formats a runtime, given in minutes, into a human-readable string.
    ///
    /// Negative values are treated as zero.
    ///
    /// - Parameter value: The runtime, in minutes.
    ///
    /// - Returns: A localized, human-readable runtime string.
    ///
    public func format(_ value: Int) -> String {
        let totalMinutes = max(0, value)

        switch displayUnit {
        case .minutesOnly:
            return minuteLabel(totalMinutes)

        case .hourMinute:
            return hourMinuteString(totalMinutes)
        }
    }

    ///
    /// Returns a copy of this format style using the given locale.
    ///
    /// - Parameter locale: The locale to apply.
    ///
    /// - Returns: A copy of the format style with the given locale.
    ///
    public func locale(_ locale: Locale) -> RuntimeFormatStyle {
        RuntimeFormatStyle(style: style, displayUnit: displayUnit, locale: locale)
    }

}

extension RuntimeFormatStyle {

    private func hourMinuteString(_ totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        guard hours > 0 else {
            return minuteLabel(minutes)
        }

        guard minutes > 0 else {
            return hourLabel(hours)
        }

        return "\(hourLabel(hours))\(separator)\(minuteLabel(minutes))"
    }

    private var separator: String {
        switch style {
        case .abbreviated:
            " "
        case .full:
            ", "
        }
    }

    private func hourLabel(_ hours: Int) -> String {
        let number = hours.formatted(.number.locale(locale))
        switch style {
        case .abbreviated:
            return "\(number)h"
        case .full:
            return "\(number) \(hours == 1 ? "hour" : "hours")"
        }
    }

    private func minuteLabel(_ minutes: Int) -> String {
        let number = minutes.formatted(.number.locale(locale))
        switch style {
        case .abbreviated where displayUnit == .minutesOnly:
            return "\(number) min"
        case .abbreviated:
            return "\(number)m"
        case .full:
            return "\(number) \(minutes == 1 ? "minute" : "minutes")"
        }
    }

}

public extension FormatStyle where Self == RuntimeFormatStyle {

    ///
    /// A runtime format style for use with `Int.formatted(_:)`.
    ///
    /// ```swift
    /// movie.runtime?.formatted(.runtimeStyle(.full, displayUnit: .hourMinute))
    /// // "2 hours, 15 minutes"
    /// ```
    ///
    /// - Parameters:
    ///   - style: The level of abbreviation applied to the formatted units.
    ///     Defaults to ``RuntimeFormatStyle/Style/abbreviated``.
    ///   - displayUnit: The units used to express the runtime. Defaults to
    ///     ``RuntimeFormatStyle/DisplayUnit/hourMinute``.
    ///
    /// - Returns: A configured ``RuntimeFormatStyle``.
    ///
    static func runtimeStyle(
        _ style: RuntimeFormatStyle.Style = .abbreviated,
        displayUnit: RuntimeFormatStyle.DisplayUnit = .hourMinute
    ) -> RuntimeFormatStyle {
        RuntimeFormatStyle(style: style, displayUnit: displayUnit)
    }

}
