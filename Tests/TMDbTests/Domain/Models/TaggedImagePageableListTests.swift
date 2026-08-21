//
//  TaggedImagePageableListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TaggedImagePageableListTests {

    @Test(
        "JSON decoding of TaggedImagePageableList with mixed media types",
        .tags(.decoding)
    )
    func decodeReturnsTaggedImagePageableList() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImagePageableList.self,
            fromResource: "tagged-image-pageable-list"
        )

        #expect(result.results.count == 5)
        #expect(result.droppedItemCount == 0)

        // `page` is 0, not 1: this endpoint ignores the `page` query parameter
        // and reports 0 on every page. The fixture captures that verbatim.
        #expect(result.page == 0)
        #expect(result.totalPages == 2)
        #expect(result.totalResults == 35)

        let tvSeriesImage = try #require(
            result.results.first { $0.id == "598795c2c3a3680d5101954a" }
        )
        guard case .tvSeries(let tvSeries) = tvSeriesImage.media else {
            Issue.record("Expected tvSeries media type")
            return
        }
        #expect(tvSeries.name == "Breaking Bad")

        let movieImage = try #require(
            result.results.first { $0.id == "5c281e9392514138cbbfb676" }
        )
        guard case .movie(let movie) = movieImage.media else {
            Issue.record("Expected movie media type")
            return
        }
        #expect(movie.title == "Crazy Horse")

        let episodeImage = try #require(
            result.results.first { $0.id == "575112659251410885001698" }
        )
        guard case .tvEpisode = episodeImage.media else {
            Issue.record("Expected tvEpisode media type")
            return
        }
    }

    ///
    /// A page whose every row is a TV series used to decode to *no results at
    /// all*, because each row was dropped before the results array was built.
    /// An empty page ends a `PagedAsyncSequence`, so `allTaggedImages` stopped
    /// there and discarded every later page too — the drop truncated the whole
    /// sequence rather than merely shortening one page.
    ///
    @Test(
        "JSON decoding of TaggedImagePageableList whose results are all TV series",
        .tags(.decoding)
    )
    func decodeReturnsTaggedImagePageableListWhenAllResultsAreTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImagePageableList.self,
            fromResource: "tagged-image-pageable-list-all-tv"
        )

        #expect(result.results.count == 3)
        #expect(result.droppedItemCount == 0)
        #expect(
            result.results.allSatisfy {
                if case .tvSeries = $0.media { true } else { false }
            }
        )
    }

    ///
    /// `tv_season` is a real nested `media_type` on this endpoint — measured on
    /// person 57755 (*True Detective* season 1) — that the library still does
    /// not model. The values below are that row's, so this exercises a media
    /// type TMDb actually sends rather than an invented one.
    ///
    @Test(
        "JSON decoding of TaggedImagePageableList skips a result with an unmodelled media type",
        .tags(.decoding)
    )
    func decodeSkipsResultWithUnmodelledMediaType() throws {
        let json = """
        {
          "page": 0,
          "results": [
            {
              "id": "52dbf5ab760ee3248d01db10",
              "aspect_ratio": 0.667,
              "file_path": "/gf5PFAwzcrRjd26zqcumqeMZV0W.jpg",
              "height": 1500,
              "width": 1000,
              "image_type": "poster",
              "vote_average": 0,
              "vote_count": 0,
              "media": {
                "id": 59780,
                "name": "Season 1",
                "media_type": "tv_season",
                "season_number": 1,
                "show_id": 46648,
                "episode_count": 8,
                "air_date": "2014-01-12",
                "vote_average": 8.7
              }
            }
          ],
          "total_pages": 1,
          "total_results": 1
        }
        """

        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImagePageableList.self,
            from: Data(json.utf8)
        )

        #expect(result.results.isEmpty)
        #expect(result.droppedItemCount == 1)
    }

    ///
    /// ADR-0019 limb 3. Only an unmodelled `media_type` may be skipped; a row
    /// whose media type *is* modelled but whose payload is malformed must fail
    /// the page loudly, or a decoder regression arrives as a quietly short
    /// page. The row below is a well-formed `"tv"` tagged image with one
    /// corrupted field.
    ///
    @Test(
        "JSON decoding of a TaggedImagePageableList page whose TV series row is malformed throws",
        .tags(.decoding)
    )
    func decodeWhenTVSeriesPageItemIsMalformedThrows() {
        let json = """
        {
          "page": 0,
          "results": [
            {
              "id": "598795c2c3a3680d5101954a",
              "aspect_ratio": 0.667,
              "file_path": "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
              "height": 3000,
              "width": 2000,
              "image_type": "poster",
              "vote_average": 5.3,
              "vote_count": 3,
              "media": {
                "id": "not-an-int",
                "name": "Breaking Bad",
                "original_name": "Breaking Bad",
                "media_type": "tv"
              }
            }
          ],
          "total_pages": 1,
          "total_results": 1
        }
        """

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(
                TaggedImagePageableList.self,
                from: Data(json.utf8)
            )
        }
    }

    ///
    /// Decoded on its own — rather than inside a tolerant array — an unmodelled
    /// media type must still surface as a `DecodingError`, so a consumer
    /// decoding their own cached JSON can catch it by type.
    ///
    @Test(
        "JSON decoding of TaggedImageMedia with an unmodelled media type throws",
        .tags(.decoding)
    )
    func decodeTaggedImageMediaWithUnmodelledMediaTypeThrows() throws {
        let json = """
        {
          "id": 59780,
          "name": "Season 1",
          "media_type": "tv_season",
          "season_number": 1,
          "show_id": 46648,
          "episode_count": 8,
          "air_date": "2014-01-12"
        }
        """

        let error = #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(
                TaggedImageMedia.self,
                from: Data(json.utf8)
            )
        }

        let decodingError = try #require(error)
        guard case .dataCorrupted = decodingError else {
            Issue.record("Expected a dataCorrupted error")
            return
        }
        #expect(
            decodingError.unknownMediaType == UnknownMediaTypeError(rawValue: "tv_season")
        )
    }

}
