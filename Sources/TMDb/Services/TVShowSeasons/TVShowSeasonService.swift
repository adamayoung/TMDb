import Combine
import Foundation

protocol TVShowSeasonService {

    func fetchDetails(forSeason seasonNumber: Int,
                      inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<TVShowSeasonDTO, TMDbError>

    func fetchImages(forSeason seasonNumber: Int,
                     inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    func fetchVideos(forSeason seasonNumber: Int,
                     inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

}
