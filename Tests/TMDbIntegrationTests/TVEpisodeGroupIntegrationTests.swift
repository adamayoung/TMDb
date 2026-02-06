//
//  TVEpisodeGroupIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
    .tags(.tvEpisodeGroup),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVEpisodeGroupIntegrationTests {

    var tvEpisodeGroupService:
        (any TVEpisodeGroupService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvEpisodeGroupService = TMDbClient(
            apiKey: apiKey
        ).tvEpisodeGroups
    }

    @Test("details")
    func details() async throws {
        let groupID = "5acf93e60e0a26346d0000ce"

        let group =
            try await tvEpisodeGroupService.details(
                forTVEpisodeGroup: groupID
            )

        #expect(group.id == groupID)
        #expect(group.name == "Netflix Collections")
        #expect((group.episodeCount ?? 0) >= 1)
        #expect((group.groupCount ?? 0) >= 1)
    }

}
