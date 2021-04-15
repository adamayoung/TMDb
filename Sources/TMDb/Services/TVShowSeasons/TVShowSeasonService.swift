import Combine
import Foundation

protocol TVShowSeasonService {

    func fetchDetails(forSeason seasonNumber: Int,
                      inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError>

    func fetchImages(forSeason seasonNumber: Int,
                     inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    func fetchVideos(forSeason seasonNumber: Int,
                     inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

}
