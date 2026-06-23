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
            id: 1399,
            cast: [
                AggregateCastMember(
                    id: 22970,
                    name: "Peter Dinklage",
                    originalName: "Peter Dinklage",
                    gender: .male,
                    profilePath: URL(string: "/9CAd7wr8QZyIN0E7nm8v1B6WkGn.jpg"),
                    roles: [
                        CastRole(
                            creditID: "5256c8b219c2956ff6047cd8",
                            character: "Tyrion 'The Halfman' Lannister",
                            episodeCount: 73
                        )
                    ],
                    knownForDepartment: "Acting",
                    isAdultOnly: false,
                    totalEpisodeCount: 73,
                    popularity: 3.6178
                )
            ],
            crew: [
                AggregateCrewMember(
                    id: 6411,
                    name: "Deborah Riley",
                    originalName: "Deborah Riley",
                    gender: .female,
                    profilePath: URL(string: "/cjhADpqdrnwB1PdDUKaBnWrIj2Q.jpg"),
                    jobs: [
                        CrewJob(
                            creditID: "54eee9e5c3a3686d5800584e",
                            job: "Production Design",
                            episodeCount: 43
                        )
                    ],
                    knownForDepartment: "Art",
                    isAdultOnly: false,
                    totalEpisodeCount: 43,
                    popularity: 0.1683
                )
            ]
        )
    }

}
