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
        let profilePath = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")

        let castMember = AggregateCastMember(
            id: 1,
            name: "Cast Member",
            originalName: "Cast Member",
            gender: .female,
            profilePath: profilePath,
            roles: [
                CastRole(creditID: "credit123", character: "Character Name", episodeCount: 10)
            ],
            knownForDepartment: "Acting",
            isAdultOnly: false,
            totalEpisodeCount: 10,
            popularity: 5
        )

        let crewMember = AggregateCrewMember(
            id: 2,
            name: "Crew Member",
            originalName: "Crew Member",
            gender: .male,
            profilePath: profilePath,
            jobs: [
                CrewJob(creditID: "credit456", job: "Executive Producer", episodeCount: 8)
            ],
            knownForDepartment: "Production",
            isAdultOnly: false,
            totalEpisodeCount: 8,
            popularity: 4
        )

        return TVSeasonAggregateCredits(id: 1, cast: [castMember], crew: [crewMember])
    }

}
