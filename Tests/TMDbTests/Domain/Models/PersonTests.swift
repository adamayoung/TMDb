//
//  PersonTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct PersonTests {

    @Test("JSON decoding of Person", .tags(.decoding))
    func testDecodeReturnsPerson() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Person.self, fromResource: "person")

        #expect(result.id == person.id)
        #expect(result.name == person.name)
        #expect(result.alsoKnownAs == person.alsoKnownAs)
        #expect(result.knownForDepartment == person.knownForDepartment)
        #expect(result.biography == person.biography)
        #expect(result.birthday == person.birthday)
        #expect(result.deathday == person.deathday)
        #expect(result.gender == person.gender)
        #expect(result.placeOfBirth == person.placeOfBirth)
        #expect(result.profilePath == person.profilePath)
        #expect(result.popularity == person.popularity)
        #expect(result.imdbID == person.imdbID)
        #expect(result.homepageURL == person.homepageURL)
    }

    @Test("JSON decoding of Person when homepage is empty string", .tags(.decoding))
    func decodeWhenHomepageIsEmptyStringReturnsPerson() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Person.self, fromResource: "person-blank-homepage")

        #expect(result.homepageURL == nil)
    }

}

extension PersonTests {

    private var person: Person {
        .init(
            id: 287,
            name: "Brad Pitt",
            alsoKnownAs: [
                "Бред Питт",
                "Бред Пітт",
                "Buratto Pitto",
                "Брэд Питт"
            ],
            knownForDepartment: "Acting",
            biography:
                "William Bradley 'Brad' Pitt (born December 18, 1963) is an American actor and film producer. Pitt has received two Academy Award nominations and four Golden Globe Award nominations, winning one. He has been described as one of the world's most attractive men, a label for which he has received substantial media attention. Pitt began his acting career with television guest appearances, including a role on the CBS prime-time soap opera Dallas in 1987. He later gained recognition as the cowboy hitchhiker who seduces Geena Davis's character in the 1991 road movie Thelma & Louise. Pitt's first leading roles in big-budget productions came with A River Runs Through It (1992) and Interview with the Vampire (1994). He was cast opposite Anthony Hopkins in the 1994 drama Legends of the Fall, which earned him his first Golden Globe nomination. In 1995 he gave critically acclaimed performances in the crime thriller Seven and the science fiction film 12 Monkeys, the latter securing him a Golden Globe Award for Best Supporting Actor and an Academy Award nomination.",
            birthday: DateFormatter.theMovieDatabase.date(from: "1963-12-18"),
            deathday: nil,
            gender: .male,
            placeOfBirth: "Shawnee, Oklahoma, USA",
            profilePath: URL(string: "/kU3B75TyRiCgE270EyZnHjfivoq.jpg"),
            popularity: 10.647,
            imdbID: "nm0000093",
            homepageURL: nil
        )
    }

}
