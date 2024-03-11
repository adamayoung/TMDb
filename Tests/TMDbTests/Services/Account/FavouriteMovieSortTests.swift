//
//  File.swift
//  
//
//  Created by Adam Young on 11/03/2024.
//

@testable import TMDb
import XCTest

final class FavouriteMovieSortTests: XCTestCase {

    func testCreatedAtWhenDefaultReturnsDescription() {
        XCTAssertEqual(FavouriteMovieSort.createdAt().description, "created_at.asc")
    }

    func testCreatedAtWhenAscendingReturnsDescription() {
        XCTAssertEqual(FavouriteMovieSort.createdAt(descending: false).description, "created_at.asc")
    }

    func testCreatedAtWhenDescendingReturnsDescription() {
        XCTAssertEqual(FavouriteMovieSort.createdAt(descending: true).description, "created_at.desc")
    }

    func testURLAppendingSortByWhenNilReturnsOriginalURL() throws {
        let sort: FavouriteMovieSort? = nil
        let expectedURL = try XCTUnwrap(URL(string: "/some/path"))

        let url = URL(string: "/some/path")?.appendingSortBy(sort)

        XCTAssertEqual(url, expectedURL)
    }

    func testURLAppendingSortByReturnsURL() throws {
        let sort: FavouriteMovieSort? = .createdAt()
        let expectedURL = try XCTUnwrap(URL(string: "/some/path?sort_by=created_at.asc"))

        let url = URL(string: "/some/path")?.appendingSortBy(sort)

        XCTAssertEqual(url, expectedURL)
    }

}
