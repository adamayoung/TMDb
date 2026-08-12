//
//  CreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .credit))
struct CreditTests {

    @Test("JSON decoding of Credit", .tags(.decoding))
    func decodeCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit"
        )

        #expect(result.id == "52542282760ee313280017f9")
        #expect(result.creditType == .cast)
        #expect(result.department == "Acting")
        #expect(result.job == "Actor")
        #expect(result.mediaType == "tv")
        #expect(result.person.id == 17419)
        #expect(result.person.name == "Bryan Cranston")

        if case .tvSeries(let tvSeries) = result.media {
            #expect(tvSeries.id == 1396)
            #expect(tvSeries.name == "Breaking Bad")
        } else {
            Issue.record("Expected TV series media type")
        }
    }

    /// The bug this guards is not the enum in isolation but the whole call:
    /// before `CreditType` tolerated `"creator"`, `details(forCredit:)` threw
    /// `TMDbError.decode` for every TV creator credit.
    @Test("JSON decoding of Credit with a creator credit type", .tags(.decoding))
    func decodeCreditWithCreatorCreditType() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit-creator"
        )

        #expect(result.id == "5257855d19c29531db28adea")
        #expect(result.creditType == .creator)
        #expect(result.department == "Creator")
        #expect(result.job == "Creator")
        #expect(result.person.name == "Steven Spielberg")

        guard case .tvSeries(let tvSeries) = result.media else {
            Issue.record("Expected TV series media type")
            return
        }

        #expect(tvSeries.id == 6227)
        #expect(tvSeries.name == "Invasion America")
    }

    @Test(
        "JSON decoding of Credit with an unknown media type throws a data corrupted error",
        .tags(.decoding)
    )
    func decodeCreditWithUnknownMediaTypeThrowsDataCorruptedError() throws {
        let data = Data(#"{"media_type": "podcast", "id": 1}"#.utf8)

        let error = #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(
                CreditMedia.self,
                from: data
            )
        }

        guard case .dataCorrupted(let context) = try #require(error) else {
            Issue.record("Expected a data corrupted error")
            return
        }

        #expect(context.debugDescription.contains("Unknown media type"))
    }

    @Test("JSON encoding of movie CreditMedia", .tags(.encoding))
    func encodeMovieCreditMedia() throws {
        let releaseDate = DateFormatter.theMovieDatabase.date(from: "1999-10-15")
        let media = CreditMedia.movie(
            .mock(id: 550, releaseDate: releaseDate, character: "Narrator")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(media)
        let result = try JSONDecoder.theMovieDatabase.decode(
            CreditMedia.self,
            from: data
        )

        guard case .movie(let movie) = result else {
            Issue.record("Expected movie media type")
            return
        }

        #expect(movie.id == 550)
        #expect(movie.releaseDate == releaseDate)
        #expect(movie.character == "Narrator")
    }

    @Test("JSON encoding of TV series CreditMedia", .tags(.encoding))
    func encodeTVSeriesCreditMedia() throws {
        let firstAirDate = DateFormatter.theMovieDatabase.date(from: "2008-01-20")
        let media = CreditMedia.tvSeries(
            .mock(id: 1396, firstAirDate: firstAirDate, character: "Walter White")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(media)
        let result = try JSONDecoder.theMovieDatabase.decode(
            CreditMedia.self,
            from: data
        )

        guard case .tvSeries(let tvSeries) = result else {
            Issue.record("Expected TV series media type")
            return
        }

        #expect(tvSeries.id == 1396)
        #expect(tvSeries.firstAirDate == firstAirDate)
        #expect(tvSeries.character == "Walter White")
    }

}
