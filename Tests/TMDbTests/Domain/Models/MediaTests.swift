//
//  MediaTests.swift
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

@Suite(.tags(.models))
struct MediaTests {

    @Test("id when movie returns movieID")
    func idWhenMovieReturnsMovieID() {
        let media = Media.movie(.theFirstOmen)

        #expect(media.id == 437_342)
    }

    @Test("id when TV series returns tvSeriesID")
    func idWhenTVSeriesReturnsTVSeriesID() {
        let media = Media.tvSeries(.bigBrother)

        #expect(media.id == 11366)
    }

    @Test("id when person returns personID")
    func idWhenPersonReturnsPersonID() {
        let media = Media.person(.bradPitt)

        #expect(media.id == 287)
    }

    @Test("id when collection returns collectionID")
    func idWhenCollectionReturnsCollectionID() {
        let media = Media.collection(.vinylAndTheVelvetUndergroundAndNico)

        #expect(media.id == 1_243_563)
    }

    @Test("JSON decoding of Media", .tags(.decoding))
    func decodeReturnsMedia() throws {
        let media: [Media] = [
            .movie(.theFirstOmen),
            .tvSeries(.bigBrother),
            .person(.bradPitt)
        ]

        let result = try JSONDecoder.theMovieDatabase.decode([Media].self, fromResource: "media")

        #expect(result == media)
    }

    @Test("JSON encoding of movie media", .tags(.encoding))
    func encodeMovieMedia() throws {
        let movie = MovieListItem.theFirstOmen
        let media = Media.movie(movie)

        let data = try JSONEncoder.theMovieDatabase.encode(media)
        let decodedMedia = try JSONDecoder.theMovieDatabase.decode(MovieListItem.self, from: data)

        #expect(decodedMedia == movie)
    }

    @Test("JSON encoding of TV series media", .tags(.encoding))
    func encodeTVSeriesMedia() throws {
        let tvSeries = TVSeriesListItem.bigBrother
        let media = Media.tvSeries(tvSeries)

        let data = try JSONEncoder.theMovieDatabase.encode(media)
        let decodedMedia = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesListItem.self,
            from: data
        )

        #expect(decodedMedia == tvSeries)
    }

    @Test("JSON encoding of person media", .tags(.encoding))
    func encodePersonMedia() throws {
        let person = PersonListItem.bradPitt
        let media = Media.person(person)

        let data = try JSONEncoder.theMovieDatabase.encode(media)
        let decodedMedia = try JSONDecoder.theMovieDatabase.decode(PersonListItem.self, from: data)

        #expect(decodedMedia == person)
    }

    @Test("JSON encoding of collection media", .tags(.encoding))
    func encodeCollectionMedia() throws {
        let collection = CollectionListItem.vinylAndTheVelvetUndergroundAndNico
        let media = Media.collection(collection)

        let data = try JSONEncoder.theMovieDatabase.encode(media)
        let decodedMedia = try JSONDecoder.theMovieDatabase.decode(
            CollectionListItem.self,
            from: data
        )

        #expect(decodedMedia == collection)
    }

}
