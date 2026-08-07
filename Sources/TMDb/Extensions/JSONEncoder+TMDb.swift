//
//  JSONEncoder+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension JSONEncoder {

    static var theMovieDatabase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.theMovieDatabase)
        return encoder
    }

    static var theMovieDatabaseAuth: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.theMovieDatabaseAuth)
        return encoder
    }

    /// The v4 counterpart of ``theMovieDatabaseV4`` decoding.
    ///
    /// It writes the `yyyy-MM-dd HH:mm:ss UTC` form for **every** date, which
    /// is what makes a v4 model round trip exactly. That form is lossless to
    /// the second, and the v4 decoder tries it first, so a day-precision date
    /// re-read after encoding still lands on the instant it started from —
    /// whereas the day-precision encoder would throw the time away and a
    /// timestamp would come back as midnight.
    ///
    /// No v4 *request* body carries a date, so this only ever affects
    /// re-encoding a decoded response.
    static var theMovieDatabaseV4: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.theMovieDatabaseAuth)
        return encoder
    }

}
