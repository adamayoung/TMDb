import Foundation
import TMDb

extension Department {

    static var mocks: [Department] {
        [
            Department(
                name: "Costume & Make-Up",
                jobs: [
                    "Set Costumer",
                    "Co-Costume Designer"
                ]
            ),
            Department(
                name: "Production",
                jobs: [
                    "Casting",
                    "ADR Voice Casting",
                    "Production Accountant"
                ]
            )
        ]
    }

}
