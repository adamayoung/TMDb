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
    /// The tolerant array wrapper has to tell an unmodelled media type apart from a
    /// genuine decode failure, and it does that by reading the `underlyingError` of a
    /// `DecodingError` raised in a **nested** `init(from:)`. This pins that the marker
    /// survives the trip out through `JSONDecoder`.
    ///
    /// It also pins the public half of the contract: what escapes is a
    /// `DecodingError` — the type every public `init(from:)` documents and that a
    /// consumer decoding their own cached JSON can still catch — never the internal
    /// marker on its own.
    ///
    @Test("an unmodelled media type escapes a nested init(from:) as a DecodingError")
    func unknownMediaTypeEscapesDecoderAsDecodingError() throws {
        let data = Data(#"{"items": [{"media_type": "podcast"}]}"#.utf8)

        let error = #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Wrapper.self, from: data)
        }

        let decodingError = try #require(error)
        #expect(decodingError.unknownMediaType == UnknownMediaTypeError(rawValue: "podcast"))
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

    @Test("marks an unmodelled media type for a string no case matches")
    func marksUnmodelledMediaTypeValue() throws {
        let data = Data(#"{"media_type": "podcast"}"#.utf8)

        let error = #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)
        }

        let decodingError = try #require(error)
        #expect(decodingError.unknownMediaType == UnknownMediaTypeError(rawValue: "podcast"))
    }

    /// The raw value reaches a public error a caller may log, so it is bounded and
    /// escaped at the construction site — a response must not be able to forge log
    /// lines through it, or bloat a log with a huge media type. The untruncated
    /// value stays on the internal marker.
    @Test("does not put a raw server string into the error message")
    func redactsRawValueInErrorMessage() throws {
        let padding = String(repeating: "a", count: 80)
        // `\n` here is a JSON escape, so the decoded value carries a real newline.
        let data = Data(#"{"media_type": "\#(padding)\nINJECTED LOG LINE"}"#.utf8)
        let hostile = padding + "\nINJECTED LOG LINE"

        let error = #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(Element.self, from: data)
        }

        let decodingError = try #require(error)
        guard case .dataCorrupted(let context) = decodingError else {
            Issue.record("Expected a dataCorrupted error")
            return
        }

        #expect(!context.debugDescription.contains("\n"))
        #expect(!context.debugDescription.contains("INJECTED"))
        #expect(context.debugDescription.count < 80)
        // The full value is still available internally for diagnosis.
        #expect(decodingError.unknownMediaType?.rawValue == hostile)
    }

    /// The three negatives below assert the *absence* of the marker, which is what
    /// keeps the tolerant wrapper from skipping them.
    @Test("does not mark an absent, null or mistyped media_type as unmodelled")
    func doesNotMarkGenuineDecodeFailures() throws {
        for json in [#"{}"#, #"{"media_type": null}"#, #"{"media_type": 7}"#] {
            let error = #expect(throws: DecodingError.self) {
                _ = try JSONDecoder.theMovieDatabase.decode(
                    Element.self, from: Data(json.utf8)
                )
            }

            let decodingError = try #require(error)
            #expect(decodingError.unknownMediaType == nil)
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
