//
//  AccountIntegrationTests.swift
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

import TMDb
import XCTest

final class AccountIntegrationTests: XCTestCase {

    var accountService: AccountService!
    var authenticationService: AuthenticationService!
    var session: Session!

    override func setUp() async throws {
        try await super.setUp()
        try configureTMDb()

        authenticationService = AuthenticationService()
        let credential = try tmdbCredential()
        session = try await authenticationService.createSession(withCredential: credential)

        accountService = AccountService()
    }

    override func tearDown() async throws {
        accountService = nil
        try await authenticationService.deleteSession(session)
        authenticationService = nil
        session = nil
        try await super.tearDown()
    }

    func testDetails() async throws {
        let details = try await accountService.details(session: session)

        XCTAssertGreaterThan(details.id, 0)
    }

    func testAddingAndRemovingFavouriteMovies() async throws {
        let accountDetails = try await accountService.details(session: session)
        let movieID = 550

        try await accountService.addFavourite(movie: movieID, accountID: accountDetails.id, session: session)

        let movieListAfterFavorited = try await accountService.favouriteMovies(
            accountID: accountDetails.id,
            session: session
        )
        let isMovieFavourited = movieListAfterFavorited.results.contains { $0.id == movieID }
        XCTAssertTrue(isMovieFavourited)

        try await accountService.removeFavourite(movie: movieID, accountID: accountDetails.id, session: session)

        let movieListAfterFavoriteRemoved = try await accountService.favouriteMovies(
            accountID: accountDetails.id,
            session: session
        )

        let isMovieFavouritedAfterRemoved = movieListAfterFavoriteRemoved.results.contains { $0.id == movieID }
        XCTAssertFalse(isMovieFavouritedAfterRemoved)
    }

    func testAddingAndRemovingFavouriteTVSeries() async throws {
        let accountDetails = try await accountService.details(session: session)
        let tvSeriesID = 2261

        try await accountService.addFavourite(tvSeries: tvSeriesID, accountID: accountDetails.id, session: session)

        let tvSeriesListAfterFavorited = try await accountService.favouriteTVSeries(
            accountID: accountDetails.id,
            session: session
        )
        let isTVSeriesFavourited = tvSeriesListAfterFavorited.results.contains { $0.id == tvSeriesID }
        XCTAssertTrue(isTVSeriesFavourited)

        try await accountService.removeFavourite(tvSeries: tvSeriesID, accountID: accountDetails.id, session: session)

        let tvSeriesListAfterFavoriteRemoved = try await accountService.favouriteTVSeries(
            accountID: accountDetails.id,
            session: session
        )

        let isTVSeriesFavouritedAfterRemoved = tvSeriesListAfterFavoriteRemoved.results.contains { $0.id == tvSeriesID }
        XCTAssertFalse(isTVSeriesFavouritedAfterRemoved)
    }

}
