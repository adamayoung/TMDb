//
//  TMDbTVSeriesService+Media.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeriesService {

    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter? = nil
    ) async throws(TMDbError) -> ImageCollection {
        let request = TVSeriesImagesRequest(id: tvSeriesID, languages: filter?.languages)

        return try await apiClient.perform(request)
    }

    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter? = nil
    ) async throws(TMDbError) -> VideoCollection {
        let request = TVSeriesVideosRequest(id: tvSeriesID, languages: filter?.languages)

        return try await apiClient.perform(request)
    }

}
