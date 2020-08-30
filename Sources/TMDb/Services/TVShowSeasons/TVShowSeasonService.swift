import Combine
import Foundation

public protocol TVShowSeasonService {

    func fetchDetails(forSeasonNumber seasonNumber: Int,
                      inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError>

    func fetchImages(forSeasonNumber seasonNumber: Int,
                     inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    func fetchVideos(forSeasonNumber seasonNumber: Int,
                     inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

}
