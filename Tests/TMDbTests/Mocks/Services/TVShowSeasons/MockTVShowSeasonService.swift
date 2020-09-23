import Combine
@testable import TMDb
import XCTest

final class MockTVShowSeasonService: TVShowSeasonService {

    var seasonDetails: TVShowSeasonDTO?
    private(set) var lastDetailsSeasonNumber: Int?
    private(set) var lastDetailsTVShowID: TVShowDTO.ID?
    var images: ImageCollectionDTO?
    private(set) var lastImagesSeasonNumber: Int?
    private(set) var lastImagesTVShowID: TVShowDTO.ID?
    var videos: VideoCollectionDTO?
    private(set) var lastVideosSeasonNumber: Int?
    private(set) var lastVideosTVShowID: TVShowDTO.ID?

    func fetchDetails(forSeason seasonNumber: Int,
                      inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<TVShowSeasonDTO, TMDbError> {
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
                     inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
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
                     inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
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
