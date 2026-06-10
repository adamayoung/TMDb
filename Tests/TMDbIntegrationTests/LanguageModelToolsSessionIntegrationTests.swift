//
//  LanguageModelToolsSessionIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// Opt-in end-to-end check that drives a real LanguageModelSession with the TMDb
// tools. Requires Apple Intelligence and is gated behind the TMDB_FM_TOOLS_EVAL
// environment variable so it never runs in ordinary CI.
#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import FoundationModels
    import Testing
    import TMDb

    @Suite(
        .serialized,
        .tags(.languageModelTools),
        .enabled(
            if: CredentialHelper.shared.hasAPIKey
                && ProcessInfo.processInfo.environment["TMDB_FM_TOOLS_EVAL"] != nil
        )
    )
    struct LanguageModelToolsSessionIntegrationTests {

        @available(macOS 26, *)
        @Test("the assistant answers a movie question using the tools")
        func answersAMovieQuestion() async throws {
            guard SystemLanguageModel.default.availability == .available else {
                return
            }

            let client = CredentialHelper.shared.makeClient()
            let session = LanguageModelSession(tools: client.languageModelTools)
            let response = try await session.respond(to: "Tell me about the movie Inception.")

            #expect(!response.content.isEmpty)
        }

    }
#endif
