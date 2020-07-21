//
//  PersonImageService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol PersonImageService {

    func fetch(forPerson personID: Int) -> AnyPublisher<PersonImageCollection, TMDbError>

}
