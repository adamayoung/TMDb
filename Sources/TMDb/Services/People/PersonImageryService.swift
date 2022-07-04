import Foundation

/// A service to fetch images of a person.
public protocol PersonImageryService {

    /// Returns the images for a person.
    ///
    /// [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's images.
    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection

}
