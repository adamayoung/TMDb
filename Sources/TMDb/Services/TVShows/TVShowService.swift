import Combine
import Foundation

public protocol TVShowService {

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

extension TVShowService {

    public func fetchReviews(forTVShow tvShowID: TVShow.ID,
                             page: Int? = nil) -> AnyPublisher<ReviewPageableList, TMDbError> {
        fetchReviews(forTVShow: tvShowID, page: page)
    }

    public func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
                                     page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        fetchRecommendations(forTVShow: tvShowID, page: page)
    }

    public func fetchSimilar(toTVShow tvShowID: TVShow.ID,
                             page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        fetchSimilar(toTVShow: tvShowID, page: page)
    }

    public func fetchPopular(page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        fetchPopular(page: page)
    }

}
