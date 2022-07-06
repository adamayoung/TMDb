import Foundation

extension String {

    static var randomID: Self {
        String(Int.randomID)
    }

    static var randomString: Self {
        UUID().uuidString
    }

}
