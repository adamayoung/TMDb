import Combine
import Foundation

protocol TVShowService {

    func fetchDetails(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError>

    func fetchCredits(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError>

    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError>

    func fetchImages(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    func fetchVideos(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
                              page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

}
