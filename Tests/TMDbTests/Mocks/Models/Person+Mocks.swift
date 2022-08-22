import Foundation
import TMDb

extension Person {

    static func mock(
        id: Int = .randomID,
        name: String = .randomString,
        alsoKnownAs: [String]? = nil,
        knownForDepartment: String? = .randomString,
        biography: String? = .randomString,
        birthday: Date? = .random,
        deathday: Date? = nil,
        gender: Gender? = .male,
        placeOfBirth: String? = .randomString,
        profilePath: URL? = .randomImagePath,
        popularity: Double? = Double.random(in: 1...10),
        imdbID: String? = .randomString,
        homepageURL: URL? = .randomWebSite
    ) -> Self {
        .init(
            id: id,
            name: name,
            alsoKnownAs: alsoKnownAs ?? [name],
            knownForDepartment: knownForDepartment,
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            gender: gender,
            placeOfBirth: placeOfBirth,
            profilePath: profilePath,
            popularity: popularity,
            imdbID: imdbID,
            homepageURL: homepageURL
        )
    }

    static var tomCruise: Self {
        .mock(id: 500, name: "Tom Cruise")
    }

    static var bradPitt: Self {
        .mock(id: 287, name: "Brad Pitt")
    }

    static var johnnyDepp: Self {
        .mock(id: 85, name: "Johnny Depp")
    }

    static var quentinTarantino: Self {
        .mock(id: 138, name: "Quentin Tarantino")
    }

}

extension Array where Element == Person {

    static var mocks: [Element] {
        [
            .tomCruise,
            .bradPitt,
            .johnnyDepp,
            .quentinTarantino
        ]
    }

}
