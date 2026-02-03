//
//  CrewJobTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models, .decoding))
struct CrewJobTests {

    @Test("JSON decoding of CrewJob")
    func decodeReturnsCrewJob() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CrewJob.self,
            fromResource: "crew-job"
        )

        #expect(result == crewJob)
    }

}

extension CrewJobTests {

    private var crewJob: CrewJob {
        CrewJob(
            creditID: "52fe4250c3a36847f80149f4",
            job: "Director",
            episodeCount: 12
        )
    }

}
