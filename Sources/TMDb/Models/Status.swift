import Foundation

public enum Status: String, Decodable {

    case rumored = "Rumored"
    case planned = "Planned"
    case inProduction = "In Production"
    case postProduction = "Post Production"
    case released = "Released"
    case canceled = "Canceled"

}
