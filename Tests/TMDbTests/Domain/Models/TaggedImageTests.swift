//
//  TaggedImageTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TaggedImageTests {

    @Test("JSON decoding of TaggedImage with movie media", .tags(.decoding))
    func decodeWithMovieMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self, fromResource: "tagged-image"
        )

        #expect(result.id == "59164af592514156f50269b6")
        #expect(result.aspectRatio == 0.667)
        #expect(result.filePath.path().contains("iOpi3ut5DhQIbrVVjlnmfy2U7dI.jpg"))
        #expect(result.height == 3000)
        #expect(result.width == 2000)
        let languageCode = try #require(result.languageCode)
        #expect(languageCode == "en")
        let countryCode = try #require(result.countryCode)
        #expect(countryCode == "US")
        #expect(result.voteAverage == 6.5)
        #expect(result.voteCount == 19)
        #expect(result.imageType == "poster")
        #expect(result.media.id == 437_342)

        guard case .movie(let movie) = result.media else {
            Issue.record("Expected movie media type")
            return
        }
        #expect(movie.title == "The First Omen")
    }

    @Test(
        "JSON decoding of TaggedImage with TV episode media",
        .tags(.decoding)
    )
    func decodeWithTVEpisodeMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-tv-episode"
        )

        #expect(result.id == "55862d0bc3a368336500170a")
        #expect(result.aspectRatio == 1.778)
        #expect(result.imageType == "still")
        #expect(result.media.id == 1_062_838)

        guard case .tvEpisode(let episode) = result.media else {
            Issue.record("Expected tvEpisode media type")
            return
        }
        #expect(episode.name == "Pilot")
        #expect(episode.episodeNumber == 1)
        #expect(episode.seasonNumber == 1)
    }

    @Test(
        "JSON decoding of TaggedImage with TV series media",
        .tags(.decoding)
    )
    func decodeWithTVSeriesMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-tv-series"
        )

        #expect(result.id == "598795c2c3a3680d5101954a")
        #expect(result.aspectRatio == 0.667)
        #expect(result.imageType == "poster")
        #expect(result.media.id == 1396)

        guard case .tvSeries(let tvSeries) = result.media else {
            Issue.record("Expected tvSeries media type")
            return
        }

        #expect(tvSeries.name == "Breaking Bad")
        #expect(tvSeries.originalName == "Breaking Bad")
        #expect(tvSeries.firstAirDate == Date(iso8601: "2008-01-20T00:00:00Z"))
        #expect(tvSeries.originCountries == ["US"])
    }

    @Test(
        "JSON encoding of TaggedImage with TV series media",
        .tags(.encoding)
    )
    func encodeWithTVSeriesMediaWritesTVMediaType() throws {
        let taggedImage = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-tv-series"
        )

        let data = try JSONEncoder.theMovieDatabase.encode(taggedImage)
        let object = try #require(
            try JSONSerialization.jsonObject(with: data) as? [String: Any]
        )
        let media = try #require(object["media"] as? [String: Any])
        #expect(media["media_type"] as? String == "tv")

        let roundTripped = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            from: data
        )
        #expect(roundTripped == taggedImage)
    }

    ///
    /// `media.id` is the **season's** identifier, not its parent series' — the
    /// two differ here (59780 vs 46648), and the `id` switch in
    /// `TaggedImageMedia` is compiler-checked only for exhaustiveness, so an arm
    /// returning the wrong one would compile.
    ///
    @Test(
        "JSON decoding of TaggedImage with TV season media",
        .tags(.decoding)
    )
    func decodeWithTVSeasonMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-tv-season"
        )

        #expect(result.id == "52dbf5ab760ee3248d01db10")
        #expect(result.aspectRatio == 0.692)
        #expect(result.imageType == "poster")
        #expect(result.media.id == 59780)

        guard case .tvSeason(let tvSeason) = result.media else {
            Issue.record("Expected tvSeason media type")
            return
        }

        #expect(tvSeason.id == 59780)
        #expect(tvSeason.name == "Season 1")
        #expect(tvSeason.seasonNumber == 1)
        #expect(tvSeason.showID == 46648)
        #expect(tvSeason.episodeCount == 8)
        #expect(tvSeason.voteAverage == 8.7)
        #expect(tvSeason.airDate == Date(iso8601: "2014-01-12T00:00:00Z"))
        #expect(
            tvSeason.posterPath == URL(string: "/gf5PFAwzcrRjd26zqcumqeMZV0W.jpg")
        )
        #expect(tvSeason.overview?.isEmpty == false)
    }

    ///
    /// The `show_id` assertion is load-bearing: it is the only place proving the
    /// new `showID` `CodingKey` — spelled `"showId"`, the post-`convertFromSnakeCase`
    /// form — maps back out to the wire's `show_id` through `.convertToSnakeCase`.
    ///
    @Test(
        "JSON encoding of TaggedImage with TV season media",
        .tags(.encoding)
    )
    func encodeWithTVSeasonMediaWritesTVSeasonMediaType() throws {
        let taggedImage = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-tv-season"
        )

        let data = try JSONEncoder.theMovieDatabase.encode(taggedImage)
        let object = try #require(
            try JSONSerialization.jsonObject(with: data) as? [String: Any]
        )
        let media = try #require(object["media"] as? [String: Any])
        #expect(media["media_type"] as? String == "tv_season")
        #expect(media["show_id"] as? Int == 46648)

        let roundTripped = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            from: data
        )
        #expect(roundTripped == taggedImage)
    }

    @Test(
        "JSON decoding of TaggedImage with collection media",
        .tags(.decoding)
    )
    func decodeWithCollectionMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-collection"
        )

        #expect(result.id == "635117c8076ce8007f0053ce")
        #expect(result.aspectRatio == 0.701)
        #expect(result.imageType == "poster")
        #expect(result.media.id == 558_216)

        guard case .collection(let collection) = result.media else {
            Issue.record("Expected collection media type")
            return
        }

        #expect(collection.title == "Venom Collection")
        #expect(collection.originalTitle == "Venom Collection")
        #expect(collection.originalLanguage == "en")
        #expect(collection.overview.isEmpty == false)
        #expect(
            collection.posterPath == URL(string: "/unpRHoS5df7VEukeukCAgHU1sV2.jpg")
        )
        #expect(
            collection.backdropPath == URL(string: "/vq340s8DxA5Q209FT8PHA6CXYOx.jpg")
        )
        #expect(collection.isAdultOnly == false)
    }

    @Test(
        "JSON encoding of TaggedImage with collection media",
        .tags(.encoding)
    )
    func encodeWithCollectionMediaWritesCollectionMediaType() throws {
        let taggedImage = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-collection"
        )

        let data = try JSONEncoder.theMovieDatabase.encode(taggedImage)
        let object = try #require(
            try JSONSerialization.jsonObject(with: data) as? [String: Any]
        )
        let media = try #require(object["media"] as? [String: Any])
        #expect(media["media_type"] as? String == "collection")
        #expect(media["title"] as? String == "Venom Collection")

        let roundTripped = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            from: data
        )
        #expect(roundTripped == taggedImage)
    }

}
