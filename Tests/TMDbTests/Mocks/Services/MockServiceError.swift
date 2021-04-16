import Foundation

struct MockServiceError: Error {

    private let message: String

    init(message: String) {
        self.message = message
    }

    var localizedDescription: String {
        message
    }

}
