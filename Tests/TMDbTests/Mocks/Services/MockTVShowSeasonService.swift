@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

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

    func fetchDetails(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID,
                      completion: @escaping (Result<TVShowSeason, TMDbError>) -> Void) {
        lastDetailsSeasonNumber = seasonNumber
        lastDetailsTVShowID = tvShowID

        guard let seasonDetails = seasonDetails else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(seasonDetails))
        }
    }

    func fetchImages(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        lastImagesSeasonNumber = seasonNumber
        lastImagesTVShowID = tvShowID

        guard let images = images else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(images))
        }
    }

    func fetchVideos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        lastVideosSeasonNumber = seasonNumber
        lastVideosTVShowID = tvShowID

        guard let videos = videos else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(videos))
        }
    }

}

#if canImport(Combine)
extension MockTVShowSeasonService {

    func detailsPublisher(forSeason seasonNumber: Int,
                          inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError> {
        lastDetailsSeasonNumber = seasonNumber
        lastDetailsTVShowID = tvShowID

        guard let seasonDetails = seasonDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(seasonDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func imagesPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        lastImagesSeasonNumber = seasonNumber
        lastImagesTVShowID = tvShowID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func videosPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        lastVideosSeasonNumber = seasonNumber
        lastVideosTVShowID = tvShowID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension MockTVShowSeasonService {

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
#endif
