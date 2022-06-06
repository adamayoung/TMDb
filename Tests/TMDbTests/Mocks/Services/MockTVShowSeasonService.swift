@testable import TMDb
import XCTest

final class MockTVShowSeasonService: TVShowSeasonService {

    var seasonDetails: TVShowSeason?
    private(set) var lastDetailsSeasonNumber: Int?
    private(set) var lastDetailsTVShowID: TVShow.ID?
    var images: ImageCollection?
    private(set) var lastImagesSeasonNumber: Int?
    private(set) var lastImagesTVShowID: TVShow.ID?
    var videos: VideoCollection?
    private(set) var lastVideosSeasonNumber: Int?
    private(set) var lastVideosTVShowID: TVShow.ID?

    func details(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeason {
        lastDetailsSeasonNumber = seasonNumber
        lastDetailsTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let seasonDetails = self.seasonDetails else {
                return
            }

            continuation.resume(returning: seasonDetails)
        }
    }

    func images(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        lastImagesSeasonNumber = seasonNumber
        lastImagesTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                return
            }

            continuation.resume(returning: images)
        }
    }

    func videos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        lastVideosSeasonNumber = seasonNumber
        lastVideosTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let videos = self.videos else {
                return
            }

            continuation.resume(returning: videos)
        }
    }

}
