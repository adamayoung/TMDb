//
//  DiscoverStubRepository.swift
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
@testable import TMDb

final class DiscoverStubRepository: DiscoverRepository {

    var moviesResult: Result<MoviePageableList, TMDbError>?
    private(set) var lastMoviesParameters: (MovieSort?, [Person.ID]?, Int?)?

    var tvSeriesResult: Result<TVSeriesPageableList, TMDbError>?
    private(set) var lastTVSeriesParameters: (TVSeriesSort?, Int?)?

    init() {}

    func movies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?) async throws -> MoviePageableList {
        lastMoviesParameters = (sortedBy, people, page)

        guard let movieList = try moviesResult?.get() else {
            preconditionFailure("moviesResult not set")
        }

        return movieList
    }

    func tvSeries(sortedBy: TVSeriesSort?, page: Int?) async throws -> TVSeriesPageableList {
        lastTVSeriesParameters = (sortedBy, page)

        guard let tvSeriesList = try tvSeriesResult?.get() else {
            preconditionFailure("tvSeriesResult not set")
        }

        return tvSeriesList
    }

}
