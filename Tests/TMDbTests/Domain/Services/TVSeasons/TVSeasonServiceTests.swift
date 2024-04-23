//
//  TVSeasonServiceTests.swift
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

final class TVSeasonServiceTests: XCTestCase {

    var service: TVSeasonService!
    var apiClient: MockAPIClient!
    var localeProvider: LocaleMockProvider!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        service = TVSeasonService(apiClient: apiClient, localeProvider: localeProvider)
    }

    override func tearDown() {
        apiClient = nil
        localeProvider = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeason() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeason.mock()
        let seasonNumber = expectedResult.seasonNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonRequest(seasonNumber: seasonNumber, tvSeriesID: tvSeriesID)

        let result = try await service.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeasonRequest, expectedRequest)
    }

    func testImagesReturnsImages() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeasonImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languageCode: localeProvider.languageCode
        )

        let result = try await service.images(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeasonImagesRequest, expectedRequest)
    }

    func testVideosReturnsVideos() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonVideosRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languageCode: localeProvider.languageCode
        )

        let result = try await service.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeasonVideosRequest, expectedRequest)
    }

}
