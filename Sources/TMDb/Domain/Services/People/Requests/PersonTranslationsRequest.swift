//
//  PersonTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonTranslationsRequest:
DecodableAPIRequest<TranslationCollection<PersonTranslationData>> {

    init(id: Person.ID) {
        let path = "/person/\(id)/translations"

        super.init(path: path)
    }

}
