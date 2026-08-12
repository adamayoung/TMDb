//
//  TMDbListServiceDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .list))
struct TMDbListServiceDetailsTests {

    var service: TMDbListService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbListService(apiClient: apiClient)
    }

    @Test("details returns media list with default parameters")
    func detailsReturnsMediaListWithDefaultParameters() async throws {
        let expectedResult = MediaList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = ListRequest(id: expectedResult.id, page: nil)

        let result = try await service.details(forList: expectedResult.id, page: nil)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? ListRequest == expectedRequest)
    }

    /// `items(forList:)` builds its page in memory from a decoded `MediaList`, so the
    /// drop count only survives if the hand-off passes it along. Every other assertion
    /// in this suite is `== 0`, which a hand-off that dropped the argument entirely
    /// would satisfy just as well — this one starts from a list that really did skip
    /// an item, so it can actually fail.
    @Test("items carries the decoded list's dropped item count into the page")
    func itemsCarriesDroppedItemCount() async throws {
        let json = """
        {
          "created_by": "Travis Bell",
          "favorite_count": 0,
          "id": 1,
          "iso_639_1": "en",
          "item_count": 2,
          "items": [
            {
              "id": 1,
              "title": "A Movie",
              "original_title": "A Movie",
              "original_language": "en",
              "overview": "An overview.",
              "media_type": "movie"
            },
            {"id": 2, "name": "A Future Thing", "media_type": "podcast"}
          ],
          "name": "Mixed",
          "poster_path": null
        }
        """
        let list = try JSONDecoder.theMovieDatabase.decode(
            MediaList.self, from: Data(json.utf8)
        )
        #expect(list.droppedItemCount == 1)
        apiClient.addResponse(.success(list))

        let result = try await service.items(forList: 1, page: nil)

        #expect(result.results.count == 1)
        #expect(result.droppedItemCount == 1)
    }

    @Test("details returns media list with page parameter")
    func detailsReturnsMediaListWithPageParameter() async throws {
        let expectedResult = MediaList.mock()
        let expectedPage = 2
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = ListRequest(id: expectedResult.id, page: expectedPage)

        let result = try await service.details(forList: expectedResult.id, page: expectedPage)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? ListRequest == expectedRequest)
    }

    @Test("details when errors throws TMDbError")
    func detailsWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forList: 1, page: nil)
        }
    }

    @Test("items returns pageable list with default parameters")
    func itemsReturnsPageableListWithDefaultParameters() async throws {
        let mediaList = MediaList.mock()
        apiClient.addResponse(.success(mediaList))
        let expectedResult = PageableListResult(
            page: mediaList.page,
            results: mediaList.items,
            totalResults: mediaList.totalResults,
            totalPages: mediaList.totalPages
        )
        let expectedRequest = ListRequest(id: mediaList.id, page: nil)

        let result = try await service.items(forList: mediaList.id, page: nil)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? ListRequest == expectedRequest)
    }

    @Test("items returns pageable list with page parameter")
    func itemsReturnsPageableListWithPageParameter() async throws {
        let mediaList = MediaList.mock()
        let expectedPage = 3
        apiClient.addResponse(.success(mediaList))
        let expectedResult = PageableListResult(
            page: mediaList.page,
            results: mediaList.items,
            totalResults: mediaList.totalResults,
            totalPages: mediaList.totalPages
        )
        let expectedRequest = ListRequest(id: mediaList.id, page: expectedPage)

        let result = try await service.items(forList: mediaList.id, page: expectedPage)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? ListRequest == expectedRequest)
    }

    @Test("items when errors throws TMDbError")
    func itemsWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.items(forList: 1, page: nil)
        }
    }

    @Test("itemStatus returns status")
    func itemStatusReturnsStatus() async throws {
        let expectedResult = MediaListItemStatus.mock()
        let listID = 1
        let mediaID = 550
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = ListItemStatusRequest(listID: listID, mediaID: mediaID)

        let result = try await service.itemStatus(forMedia: mediaID, inList: listID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? ListItemStatusRequest == expectedRequest)
    }

    @Test("itemStatus when errors throws TMDbError")
    func itemStatusWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.itemStatus(forMedia: 550, inList: 1)
        }
    }

}
