import Foundation
import XCTest

#if canImport(Combine)
import Combine
#endif

#if canImport(Combine)
extension XCTestCase {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func waitFor<Output, Failure: Error>(publisher: AnyPublisher<Output, Failure>,
                                         storeIn cancellables: inout Set<AnyCancellable>) throws -> Output? {
        let expectation = XCTestExpectation(description: "await")
        var result: Result<Output, Failure>?
        publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                result = .failure(error)

            default:
                break
            }

            expectation.fulfill()
        }, receiveValue: { value in
            result = .success(value)
        })
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        switch result {
        case .success(let output):
            return output

        case .failure(let error):
            throw error

        case .none:
            return nil
        }
    }

}
#endif
