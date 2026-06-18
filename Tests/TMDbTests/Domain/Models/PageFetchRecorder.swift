//
//  PageFetchRecorder.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Records the pages a paginated sequence fetches, in order, for prefetch tests.
///
/// An actor so concurrent fetches (the current page plus an in-flight prefetch)
/// record without a data race — unlike `MockAPIClient`, which is unsynchronised.
actor PageFetchRecorder {

    private(set) var startedPages: [Int] = []
    private(set) var cancelledPages: [Int] = []

    func recordStart(_ page: Int) {
        startedPages.append(page)
    }

    func recordCancellation(_ page: Int) {
        cancelledPages.append(page)
    }

    var count: Int {
        startedPages.count
    }

    func wasCancelled(_ page: Int) -> Bool {
        cancelledPages.contains(page)
    }

}
