//
//  AccountEndpointTests.swift
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

@testable import TMDb
import XCTest

final class AccountEndpointTests: XCTestCase {

    func testDetailsEndpointReturnsURL() throws {
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(URL(string: "/account?session_id=\(session.sessionID)"))

        let url = AccountEndpoint.details(sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteMoviesEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/movies?session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteMovies(accountID: accountDetails.id, sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteMoviesWhenSortedByIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/movies"
                + "?sort_by=\(sortedBy.description)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteMovies(
            sortedBy: sortedBy,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteMoviesWhenPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/movies?page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteMovies(
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteMoviesWhenSortedByAndPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/movies"
                + "?sort_by=\(sortedBy.description)&page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteMovies(
            sortedBy: sortedBy,
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteTVSeriesEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/tv?session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteTVSeries(accountID: accountDetails.id, sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteTVSeriesWhenSortedByIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/tv"
                + "?sort_by=\(sortedBy.description)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteTVSeries(
            sortedBy: sortedBy,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteTVSeriesWhenPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/tv?page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteTVSeries(
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testFavouriteTVSeriesWhenSortedByAndPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite/tv"
                + "?sort_by=\(sortedBy.description)&page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.favouriteTVSeries(
            sortedBy: sortedBy,
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testAddFavouriteEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/favorite?session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.addFavourite(accountID: accountDetails.id, sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieWatchlistEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/movies?session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.movieWatchlist(accountID: accountDetails.id, sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieWatchlistWhenSortedByIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/movies"
                + "?sort_by=\(sortedBy.description)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.movieWatchlist(
            sortedBy: sortedBy,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieWatchlistWhenPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/movies?page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.movieWatchlist(
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieWatchlistWhenSortedByAndPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/movies"
                + "?sort_by=\(sortedBy.description)&page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.movieWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWatchlistEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/tv?session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.tvSeriesWatchlist(accountID: accountDetails.id, sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWatchlistWhenSortedByIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/tv"
                + "?sort_by=\(sortedBy.description)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.tvSeriesWatchlist(
            sortedBy: sortedBy,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWatchlistWhenPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/tv?page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.tvSeriesWatchlist(
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWatchlistWhenSortedByAndPageIncludedEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let page = 2
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist/tv"
                + "?sort_by=\(sortedBy.description)&page=\(page)&session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.tvSeriesWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: accountDetails.id,
            sessionID: session.sessionID
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testAddToWatchlistEndpointReturnsURL() throws {
        let accountDetails = AccountDetails.mock()
        let session = Session.mock()
        let expectedURL = try XCTUnwrap(
            URL(string: "/account/\(accountDetails.id)/watchlist?session_id=\(session.sessionID)")
        )

        let url = AccountEndpoint.addToWatchlist(accountID: accountDetails.id, sessionID: session.sessionID).path

        XCTAssertEqual(url, expectedURL)
    }

}
