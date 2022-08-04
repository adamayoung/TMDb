import Foundation

extension Int {

    static var randomID: Self {
        .random(in: 1...10000000)
    }

}
