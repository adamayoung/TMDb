import Foundation

extension Date {

    static var random: Self {
        let date = Date().timeIntervalSince1970
        let timeInterval = Double.random(in: 1118839159...now)
        return Date(timeIntervalSince1970: timeInterval)
    }

}
