//
//  ImageProvidingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ImageProvidingTests {

    var configuration: ImagesConfiguration

    init() throws {
        self.configuration = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
    }

    @Test("Movie poster and backdrop URLs")
    func moviePosterAndBackdropURLs() throws {
        let movie = try Movie(
            id: 1,
            title: "Movie",
            posterPath: #require(URL(string: "/poster.jpg")),
            backdropPath: #require(URL(string: "/backdrop.jpg"))
        )

        let posterURL = movie.posterURL(using: configuration, size: .width(500))
        let backdropURL = movie.backdropURL(using: configuration, size: .width(1280))

        #expect(posterURL == URL(string: "https://image.tmdb.org/t/p/w500/poster.jpg"))
        #expect(backdropURL == URL(string: "https://image.tmdb.org/t/p/w1280/backdrop.jpg"))
    }

    @Test("Movie poster URL when path is nil returns nil")
    func moviePosterURLWhenPathIsNilReturnsNil() {
        let movie = Movie(id: 1, title: "Movie", posterPath: nil)

        let posterURL = movie.posterURL(using: configuration, size: .width(500))

        #expect(posterURL == nil)
    }

    @Test("Person profile URL")
    func personProfileURL() throws {
        let person = try Person(
            id: 1,
            name: "Person",
            gender: .unknown,
            profilePath: #require(URL(string: "/profile.jpg"))
        )

        let profileURL = person.profileURL(using: configuration, size: .height(632))

        #expect(profileURL == URL(string: "https://image.tmdb.org/t/p/h632/profile.jpg"))
    }

    @Test("Network logo URL")
    func networkLogoURL() throws {
        let network = try Network(
            id: 1,
            name: "Network",
            logoPath: #require(URL(string: "/logo.jpg"))
        )

        let logoURL = network.logoURL(using: configuration, size: .width(154))

        #expect(logoURL == URL(string: "https://image.tmdb.org/t/p/w154/logo.jpg"))
    }

    @Test("TVEpisode still URL")
    func tvEpisodeStillURL() throws {
        let episode = try TVEpisode(
            id: 1,
            name: "Episode",
            episodeNumber: 1,
            seasonNumber: 1,
            stillPath: #require(URL(string: "/still.jpg"))
        )

        let stillURL = episode.stillURL(using: configuration, size: .width(300))

        #expect(stillURL == URL(string: "https://image.tmdb.org/t/p/w300/still.jpg"))
    }

    @Test("Movie poster URL defaults to original size")
    func moviePosterURLDefaultsToOriginalSize() throws {
        let movie = try Movie(
            id: 1,
            title: "Movie",
            posterPath: #require(URL(string: "/poster.jpg"))
        )

        let posterURL = movie.posterURL(using: configuration)

        #expect(posterURL == URL(string: "https://image.tmdb.org/t/p/original/poster.jpg"))
    }

    @Test("Movie poster URL with unsupported size returns nil")
    func moviePosterURLWithUnsupportedSizeReturnsNil() throws {
        let movie = try Movie(
            id: 1,
            title: "Movie",
            posterPath: #require(URL(string: "/poster.jpg"))
        )

        let posterURL = movie.posterURL(using: configuration, size: .width(99999))

        #expect(posterURL == nil)
    }

    @Test("TVSeries conforms to both poster and backdrop providing")
    func tvSeriesPosterAndBackdrop() throws {
        let series = try TVSeries(
            id: 1,
            name: "Series",
            posterPath: #require(URL(string: "/poster.jpg")),
            backdropPath: #require(URL(string: "/backdrop.jpg"))
        )

        let posterURL = series.posterURL(using: configuration, size: .width(342))
        let backdropURL = series.backdropURL(using: configuration, size: .width(780))

        #expect(posterURL == URL(string: "https://image.tmdb.org/t/p/w342/poster.jpg"))
        #expect(backdropURL == URL(string: "https://image.tmdb.org/t/p/w780/backdrop.jpg"))
    }

}
