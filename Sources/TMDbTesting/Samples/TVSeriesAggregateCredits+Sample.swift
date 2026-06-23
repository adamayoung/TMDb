//
//  TVSeriesAggregateCredits+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeriesAggregateCredits {

    /// A sample `TVSeriesAggregateCredits` for use in tests and previews.
    static var sample: TVSeriesAggregateCredits {
        TVSeriesAggregateCredits(
            id: 1,
            cast: [
                AggregateCastMember(
                    id: 74568,
                    name: "Chris Hemsworth",
                    originalName: "Chris Hemsworth",
                    gender: .male,
                    profilePath: URL(string: "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg"),
                    roles: [
                        CastRole(
                            creditID: "62c8c25290b87e00f53973fb",
                            character: "Thor Odinson",
                            episodeCount: 8
                        )
                    ],
                    knownForDepartment: "Acting",
                    isAdultOnly: false,
                    totalEpisodeCount: 8,
                    popularity: 10.5
                )
            ],
            crew: [
                AggregateCrewMember(
                    id: 1,
                    name: "Crew Name",
                    originalName: "Crew Original Name",
                    gender: .male,
                    profilePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    jobs: [
                        CrewJob(
                            creditID: "62c8c27f3d4d96004c9f1996",
                            job: "Executive Producer",
                            episodeCount: 8
                        )
                    ],
                    knownForDepartment: "Production",
                    isAdultOnly: false,
                    totalEpisodeCount: 8,
                    popularity: 5.2
                )
            ]
        )
    }

}
