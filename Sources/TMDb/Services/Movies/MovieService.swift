import Combine
import Foundation

protocol MovieService {

    func fetchDetails(forMovie id: MovieDTO.ID) -> AnyPublisher<MovieDTO, TMDbError>

    func fetchCredits(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError>

    func fetchReviews(forMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError>

    func fetchImages(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    func fetchVideos(forMovie movieID: MovieDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

    func fetchRecommendations(forMovie movieID: MovieDTO.ID,
                              page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    func fetchSimilar(toMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

}
