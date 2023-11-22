import Foundation

extension TMDbError {

    init(error: Error) {
        guard let apiError = error as? TMDbAPIError else {
            self = .unknown
            return
        }

        switch apiError {
        case .notFound:
            self = .notFound

        case .network(let error):
            self = .network(error)

        default:
            self = .apiError(apiError)
        }
    }

}
