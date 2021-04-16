import Foundation

extension String {

    static var randomID: Self {
        String(Int.randomID)
    }

    static var randomString: Self {
        let length = Int.random(in: 20...10000)
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int.random(in: 0...(allowedChars.count - 1))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }

}
