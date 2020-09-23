import Foundation

extension URL {

    static var tmdbAPIBaseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    static var tmdbImageBaseURL: URL {
        URL(string: "https://image.tmdb.org/t/p")!
    }

}
