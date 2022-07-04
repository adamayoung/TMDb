import Foundation

actor Serialiser {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func decode<T: Decodable>(_ data: Data) async throws -> T {
        let result: T
        do {
            result = try decoder.decode(T.self, from: data)
        } catch let error {
            throw TMDbError.decode(error)
        }

        return result
    }

}
