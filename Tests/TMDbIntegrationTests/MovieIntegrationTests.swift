//
//  MovieIntegrationTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.movie),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct MovieIntegrationTests {

    var movieService: (any MovieService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.movieService = TMDbClient(apiKey: apiKey).movies
    }

    @Test("details")
    func details() async throws {
        let movieID = 346_698

        let movie = try await movieService.details(forMovie: movieID)

        #expect(movie.id == movieID)
        #expect(movie.title == "Barbie")
    }

    @Test("credits")
    func credits() async throws {
        let movieID = 346_698

        let credits = try await movieService.credits(forMovie: movieID)

        #expect(credits.id == movieID)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("reviews")
    func reviews() async throws {
        let movieID = 346_698

        let reviewList = try await movieService.reviews(forMovie: movieID)

        #expect(!reviewList.results.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let movieID = 346_698

        let imageCollection = try await movieService.images(forMovie: movieID)

        #expect(imageCollection.id == movieID)
        #expect(!imageCollection.posters.isEmpty)
        #expect(!imageCollection.logos.isEmpty)
        #expect(!imageCollection.backdrops.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let movieID = 346_698

        let videoCollection = try await movieService.videos(forMovie: movieID)

        #expect(videoCollection.id == movieID)
        #expect(!videoCollection.results.isEmpty)
    }

    @Test("recommendations")
    func recommendations() async throws {
        let movieID = 921_636

        let recommendationList = try await movieService.recommendations(forMovie: movieID)

        #expect(!recommendationList.results.isEmpty)
    }

    @Test("similar")
    func similar() async throws {
        let movieID = 921_636

        let movieList = try await movieService.similar(toMovie: movieID)

        #expect(!movieList.results.isEmpty)
    }

    @Test("nowPlaying")
    func nowPlaying() async throws {
        let movieList = try await movieService.nowPlaying()

        #expect(!movieList.results.isEmpty)
    }

    @Test("popular")
    func popular() async throws {
        let movieList = try await movieService.popular()

        #expect(!movieList.results.isEmpty)
    }

    @Test("topRated")
    func topRated() async throws {
        let movieList = try await movieService.topRated()

        #expect(!movieList.results.isEmpty)
    }

    @Test("upcoming")
    func upcoming() async throws {
        let movieList = try await movieService.upcoming()

        #expect(!movieList.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let movieID = 346_698

        let linksCollection = try await movieService.externalLinks(forMovie: movieID)

        #expect(linksCollection.id == movieID)
        #expect(linksCollection.imdb != nil)
        #expect(linksCollection.wikiData != nil)
        #expect(linksCollection.facebook != nil)
        #expect(linksCollection.instagram != nil)
        #expect(linksCollection.twitter != nil)
    }

}
