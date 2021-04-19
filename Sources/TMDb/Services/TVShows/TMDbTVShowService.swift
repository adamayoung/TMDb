import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbTVShowService: TVShowService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forTVShow id: TVShow.ID, completion: @escaping (Result<TVShow, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id), completion: completion)
    }

    func fetchCredits(forTVShow tvShowID: TVShow.ID, completion: @escaping (Result<ShowCredits, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID), completion: completion)
    }

    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int?,
                      completion: @escaping (Result<ReviewPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page), completion: completion)
    }

    func fetchImages(forTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID), completion: completion)
    }

    func fetchVideos(forTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID), completion: completion)
    }

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID, page: Int?,
                              completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page), completion: completion)
    }

    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page), completion: completion)
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowsEndpoint.popular(page: page), completion: completion)
    }

}

#if canImport(Combine)
extension TMDbTVShowService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func detailsPublisher(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func creditsPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func reviewsPublisher(forTVShow tvShowID: TVShow.ID,
                          page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func imagesPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func videosPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                  page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func similarPublisher(toTVShow tvShowID: TVShow.ID,
                          page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func popularPublisher(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
    }

}
#endif
