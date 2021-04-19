import Foundation

extension Date {

    static var random: Self {
        let date = Date().timeIntervalSince1970
        let timeInterval = Double.random(in: 1118839159...date)
        return Date(timeIntervalSince1970: timeInterval)
    }

}
