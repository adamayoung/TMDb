//
//  TVEpisode+Mocks.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
import TMDb

extension TVEpisode {

    static func mock(
        id: Int = 1,
        name: String = "TV Episode Name",
        episodeNumber: Int = 3,
        seasonNumber: Int = 2,
        overview: String? = "Overview for TV Episode",
        airDate: Date? = Date(iso8601: "2013-11-15T10:20:00Z"),
        productionCode: String? = nil,
        stillPath: URL? = nil,
        crew: [CrewMember]? = nil,
        guestStars: [CastMember]? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) -> TVEpisode {
        TVEpisode(
            id: id,
            name: name,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            productionCode: productionCode,
            stillPath: stillPath,
            crew: crew,
            guestStars: guestStars,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }

}

extension [TVEpisode] {

    static var mocks: [TVEpisode] {
        [.mock(), .mock(), .mock(), .mock()]
    }

}
