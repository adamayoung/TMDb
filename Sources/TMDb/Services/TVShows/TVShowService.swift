import Combine
import Foundation

protocol TVShowService {

    func fetchDetails(forTVShow id: TVShowDTO.ID) -> AnyPublisher<TVShowDTO, TMDbError>

    func fetchCredits(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ShowCredits, TMDbError>

    func fetchReviews(forTVShow tvShowID: TVShowDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError>

    func fetchImages(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    func fetchVideos(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

    func fetchRecommendations(forTVShow tvShowID: TVShowDTO.ID,
                              page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    func fetchSimilar(toTVShow tvShowID: TVShowDTO.ID, page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

}
