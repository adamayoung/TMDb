//
//  KeyedDecodingContainerMediaTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct KeyedDecodingContainerMediaTypeTests {

    private enum MediaType: String, Equatable {
        case movie
        case tvSeries = "tv"
    }

    private struct Element: Decodable {
        let mediaType: MediaType

        private enum CodingKeys: String, CodingKey {
            case mediaType
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.mediaType = try container.decodeMediaType(MediaType.self, forKey: .mediaType)
        }
    }

    private struct Wrapper: Decodable {
        let items: [Element]
    }

    ///
    /// The whole decode-tolerance design rests on this: a custom, non-`DecodingError`
    /// error thrown from a **nested** `init(from:)` must escape `JSONDecoder.decode`
    /// catchable as itself, so the tolerant array wrapper can distinguish it from a
    /// genuine decode failure.
    ///
    /// Verified by spike on macOS Foundation. Linux CI uses swift-corelibs-foundation's
    /// separate `JSONDecoder`, so this is a permanent canary rather than a throwaway
    /// spike — if it ever fails, throw `DecodingError.dataCorrupted` carrying the
    /// sentinel as its `underlyingError` and match on that instead.
    ///
    @Test("an UnknownMediaTypeError from a nested init(from:) escapes JSONDecoder unwrapped")
    func unknownMediaTypeErrorEscapesDecoderUnwrapped() {
        let data = Data(#"{"items": [{"media_type": "podcast"}]}"#.utf8)

        #expect(throws: UnknownMediaTypeError(rawValue: "podcast")) {
            _ = try JSONDecoder.theMovieDatabase.decode(Wrapper.self, from: data)
        }
    }

    @Test("decodes a movie media type")
    func decodesMovieMediaType() throws {
        let data = Data(#"{"media_type": "movie"}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)

        #expect(result.mediaType == .movie)
    }

    @Test("decodes a TV series media type")
    func decodesTVSeriesMediaType() throws {
        let data = Data(#"{"media_type": "tv"}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)

        #expect(result.mediaType == .tvSeries)
    }

    @Test("throws UnknownMediaTypeError for a string no case matches")
    func throwsUnknownMediaTypeErrorForUnmodelledValue() {
        let data = Data(#"{"media_type": "podcast"}"#.utf8)

        #expect(throws: UnknownMediaTypeError(rawValue: "podcast")) {
            _ = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)
        }
    }

    // The next three are the guard against tolerance silently widening. Decoding the
    // enum with `try?` would treat all three as "unmodelled" and skip the element,
    // which is the unbounded tolerance this whole change exists to remove.

    @Test("throws a DecodingError - not the sentinel - when the key is absent")
    func throwsDecodingErrorWhenKeyAbsent() {
        let data = Data(#"{}"#.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)
        }
    }

    @Test("throws a DecodingError - not the sentinel - when the value is null")
    func throwsDecodingErrorWhenValueIsNull() {
        let data = Data(#"{"media_type": null}"#.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)
        }
    }

    @Test("throws a DecodingError - not the sentinel - when the value is not a string")
    func throwsDecodingErrorWhenValueIsNotAString() {
        let data = Data(#"{"media_type": 7}"#.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)
        }
    }

    // MARK: - Tolerant arrays

    private struct Page: Decodable {
        let items: [Element]
        let dropped: Int

        private enum CodingKeys: String, CodingKey {
            case items
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let decoded = try container.decodeSkippingUnknownMediaTypes(
                Element.self, forKey: .items
            )
            self.items = decoded.elements
            self.dropped = decoded.dropped
        }
    }

    private struct OptionalPage: Decodable {
        let items: [Element]?
        let dropped: Int

        private enum CodingKeys: String, CodingKey {
            case items
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let decoded = try container.decodeSkippingUnknownMediaTypesIfPresent(
                Element.self, forKey: .items
            )
            self.items = decoded.elements
            self.dropped = decoded.dropped
        }
    }

    @Test("keeps every element when all media types are modelled")
    func keepsEveryModelledElement() throws {
        let data = Data(#"{"items": [{"media_type": "movie"}, {"media_type": "tv"}]}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(Page.self, from: data)

        #expect(result.items.count == 2)
        #expect(result.dropped == 0)
    }

    @Test("skips only the element with an unmodelled media type, and counts it")
    func skipsAndCountsUnmodelledElement() throws {
        let json = """
        {"items": [{"media_type": "movie"}, {"media_type": "podcast"}, {"media_type": "tv"}]}
        """

        let result = try JSONDecoder.theMovieDatabase.decode(Page.self, from: Data(json.utf8))

        #expect(result.items.map(\.mediaType) == [.movie, .tvSeries])
        #expect(result.dropped == 1)
    }

    /// The loud half of the policy, and the behaviour this change exists to
    /// introduce: before it, an element that failed for *any* reason was dropped
    /// silently, so a decoder regression showed up as a quietly short page.
    @Test("propagates a genuine DecodingError instead of skipping the element")
    func propagatesGenuineDecodingError() {
        let json = """
        {"items": [{"media_type": "movie"}, {"media_type": 7}]}
        """

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Page.self, from: Data(json.utf8))
        }
    }

    @Test("decodes an absent key as an empty array")
    func decodesAbsentKeyAsEmptyArray() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Page.self, from: Data(#"{}"#.utf8))

        #expect(result.items.isEmpty)
        #expect(result.dropped == 0)
    }

    /// `nil` and `[]` are different on a public optional — the synthesized encoder
    /// writes the key for one and omits it for the other — so the `IfPresent`
    /// variant must not collapse them.
    @Test("decodes an absent key as nil for the IfPresent variant")
    func decodesAbsentKeyAsNilWhenOptional() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            OptionalPage.self, from: Data(#"{}"#.utf8)
        )

        #expect(result.items == nil)
        #expect(result.dropped == 0)
    }

}
