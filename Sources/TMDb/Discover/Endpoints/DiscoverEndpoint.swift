import Foundation

enum DiscoverEndpoint {
    
    case movies(sortedBy: MovieSort? = nil, people: [Person.ID]? = nil, page: Int? = nil)
    case moviesFiltered(sortedBy: MovieSort? = nil, filters: [String: String] = [:], page: Int? = nil)
    case tvSeries(sortedBy: TVSeriesSort? = nil, page: Int? = nil)
    case tvSeriesFiltered(sortedBy: TVSeriesSort? = nil, filters: [String: String] = [:], page: Int? = nil)
    
    
}

extension DiscoverEndpoint: Endpoint {
    
    private static let basePath = URL(string: "/discover")!
    
    var path: URL {
        switch self {
            case .movies(let sortedBy, let people, let page):
                return Self.basePath
                    .appendingPathComponent("movie")
                    .appendingSortBy(sortedBy)
                    .appendingWithPeople(people)
                    .appendingPage(page)
                
            case .tvSeries(let sortedBy, let page):
                return Self.basePath
                    .appendingPathComponent("tv")
                    .appendingSortBy(sortedBy)
                    .appendingPage(page)
            case .moviesFiltered(sortedBy: let sortedBy, let filters, page: let page):
                return Self.basePath
                    .appendingPathComponent("movie")
                    .appendingSortBy(sortedBy)
                    .appendingFilters(filters)
                    .appendingPage(page)
            case .tvSeriesFiltered(sortedBy: let sortedBy, let filters, page: let page):
                return Self.basePath
                    .appendingPathComponent("tv")
                    .appendingSortBy(sortedBy)
                    .appendingFilters(filters)
                    .appendingPage(page)
        }
    }
    
}
