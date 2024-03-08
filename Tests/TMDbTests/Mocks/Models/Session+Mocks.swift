import Foundation
import TMDb

extension Session {

    static func mock(
        success: Bool = true,
        sessionID: String = "abc123"
    ) -> Session {
        Session(
            success: success,
            sessionID: sessionID
        )
    }

}
