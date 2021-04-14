import Combine
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

    func fetchDetails(forSeason seasonNumber: Int,
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

    func fetchImages(forSeason seasonNumber: Int,
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

    func fetchVideos(forSeason seasonNumber: Int,
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
