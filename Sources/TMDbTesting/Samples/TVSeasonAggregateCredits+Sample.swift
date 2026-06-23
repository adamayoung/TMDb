//
//  TVSeasonAggregateCredits+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeasonAggregateCredits {

    ///
    /// A sample TV season aggregate credits, for use in tests and previews.
    ///
    static var sample: TVSeasonAggregateCredits {
        let profilePath = URL(string: "/9CAd7wr8QZyIN0E7nm8v1B6WkGn.jpg")

        let castMember = AggregateCastMember(
            id: 22970,
            name: "Peter Dinklage",
            originalName: "Peter Dinklage",
            gender: .male,
            profilePath: profilePath,
            roles: [
                CastRole(
                    creditID: "5256c8b219c2956ff6047cd8",
                    character: "Tyrion 'The Halfman' Lannister",
                    episodeCount: 10
                )
            ],
            knownForDepartment: "Acting",
            isAdultOnly: false,
            totalEpisodeCount: 10,
            popularity: 3.6178
        )

        let crewMember = AggregateCrewMember(
            id: 8410,
            name: "Richard Roberts",
            originalName: "Richard Roberts",
            gender: .male,
            profilePath: profilePath,
            jobs: [
                CrewJob(creditID: "5c6d16640e0a262c999fc3c9", job: "Set Decoration", episodeCount: 10)
            ],
            knownForDepartment: "Art",
            isAdultOnly: false,
            totalEpisodeCount: 10,
            popularity: 0.2767
        )

        return TVSeasonAggregateCredits(id: 3624, cast: [castMember], crew: [crewMember])
    }

}
