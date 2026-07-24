//
//  TMDbTestFixturesExports.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// Shared mocks, sample factories, and test utilities live in the
// TMDbTestFixtures target so that both TMDbTests and TMDbIntelligenceTests can
// use one canonical copy. Re-export them here so every file in this target sees
// them without an explicit import.
@_exported import TMDbTestFixtures
