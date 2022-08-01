@testable import TMDb
import XCTest

final class MockTVShowEpisodeService: TVShowEpisodeService {

    var episodeDetails: TVShowEpisode?
    private(set) var lastDetailsEpisodeNumber: Int?
    private(set) var lastDetailsSeasonNumber: Int?
    private(set) var lastDetailsTVShowID: TVShow.ID?
    var images: TVShowEpisodeImageCollection?
    private(set) var lastImagesEpisodeNumber: Int?
    private(set) var lastImagesSeasonNumber: Int?
    private(set) var lastImagesTVShowID: TVShow.ID?
    var videos: VideoCollection?
    private(set) var lastVideosEpisodeNumber: Int?
    private(set) var lastVideosSeasonNumber: Int?
    private(set) var lastVideosTVShowID: TVShow.ID?

    func details(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisode {
        lastDetailsEpisodeNumber = episodeNumber
        lastDetailsSeasonNumber = seasonNumber
        lastDetailsTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let episodeDetails = self.episodeDetails else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: episodeDetails)
        }
    }

    func images(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisodeImageCollection {
        lastImagesEpisodeNumber = episodeNumber
        lastImagesSeasonNumber = seasonNumber
        lastImagesTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: images)
        }
    }

    func videos(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        lastVideosEpisodeNumber = episodeNumber
        lastVideosSeasonNumber = seasonNumber
        lastVideosTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let videos = self.videos else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: videos)
        }
    }

}
