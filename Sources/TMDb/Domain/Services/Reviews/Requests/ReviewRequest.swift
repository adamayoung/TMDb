//
//  ReviewRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ReviewRequest: DecodableAPIRequest<Review> {

    init(id: Review.ID) {
        let path = "/review/\(id)"

        super.init(path: path)
    }

}
