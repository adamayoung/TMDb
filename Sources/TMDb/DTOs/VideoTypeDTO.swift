import Foundation

public enum VideoTypeDTO: String, Decodable, Equatable {

    case trailer = "Trailer"
    case teaser = "Teaser"
    case clip = "Clip"
    case openingCredits = "Opening Credits"
    case featurette = "Featurette"
    case behindTheScenes = "Behind the Scenes"
    case bloopers = "Bloopers"

}
