import Combine
import Foundation

public protocol TVShowService {

    func fetchDetails(forTVShow id: TVShow.ID, include: [TVShowDetailsIncludeKey]?) -> AnyPublisher<TVShow, TMDbError>

    func fetchCredits(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError>

    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<ReviewPageableListResult, TMDbError>

    func fetchImages(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    func fetchVideos(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
                              page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

}

extension TVShowService {

    public func fetchDetails(forTVShow id: TVShow.ID,
                             include: [TVShowDetailsIncludeKey]? = nil) -> AnyPublisher<TVShow, TMDbError> {
        fetchDetails(forTVShow: id, include: include)
    }

    public func fetchReviews(forTVShow tvShowID: TVShow.ID,
                             page: Int? = nil) -> AnyPublisher<ReviewPageableListResult, TMDbError> {
        fetchReviews(forTVShow: tvShowID, page: page)
    }

    public func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
                                     page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        fetchRecommendations(forTVShow: tvShowID, page: page)
    }

    public func fetchSimilar(toTVShow tvShowID: TVShow.ID,
                             page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        fetchSimilar(toTVShow: tvShowID, page: page)
    }

    public func fetchPopular(page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        fetchPopular(page: page)
    }

}
