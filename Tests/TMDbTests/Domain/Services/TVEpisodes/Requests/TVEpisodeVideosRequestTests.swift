//
//  TVEpisodeVideosRequestTests.swift
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

@Suite(.tags(.requests, .tvEpisode))
struct TVEpisodeVideosRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVEpisodeVideosRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.path == "/tv/3/season/2/episode/1/videos")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVEpisodeVideosRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with languages")
    func queryItemsWithLanguages() {
        let request = TVEpisodeVideosRequest(
            episodeNumber: 1,
            seasonNumber: 2,
            tvSeriesID: 3,
            languages: ["en-GB", "fr"]
        )

        #expect(request.queryItems["include_video_language"] == "en-GB,fr")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVEpisodeVideosRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVEpisodeVideosRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVEpisodeVideosRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.body == nil)
    }

}
