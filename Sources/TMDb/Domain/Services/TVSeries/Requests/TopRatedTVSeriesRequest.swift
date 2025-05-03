import Foundation


final class TopRatedTVSeriesRequest: DecodableAPIRequest<TVSeriesPageableList> {

      init(page: Int? = nil, language: String? = nil) {
        let path = "/tv/top_rated"
        let queryItems = APIRequestQueryItems(page: page, language: language)

        super.init(path: path, queryItems: queryItems)
    }
}
