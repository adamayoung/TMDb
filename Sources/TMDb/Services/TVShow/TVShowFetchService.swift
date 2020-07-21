//
//  TVShowFetchService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowFetchService {

    func fetch(id: Int) -> AnyPublisher<TVShow, TMDbError>

}
