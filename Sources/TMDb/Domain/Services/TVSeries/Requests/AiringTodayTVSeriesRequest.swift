import Foundation

final class AiringTodayTVSeriesRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(page: Int? = nil, language: String? = nil) {
        let path = "/tv/popular"
        let queryItems = APIRequestQueryItems(page: page, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}
