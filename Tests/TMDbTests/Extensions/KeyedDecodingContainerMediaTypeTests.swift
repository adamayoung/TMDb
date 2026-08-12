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

}
