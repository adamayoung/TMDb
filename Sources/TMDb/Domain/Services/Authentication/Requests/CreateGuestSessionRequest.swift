//
//  CreateGuestSessionRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateGuestSessionRequest: DecodableAPIRequest<GuestSession> {

    init() {
        let path = "/authentication/guest_session/new"

        super.init(path: path)
    }

}
