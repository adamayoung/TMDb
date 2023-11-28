//
//  ShowWatchProviderResult.swift
//
//
//  Created by Mikko Kuivanen on 5.9.2023.
//

import Foundation

struct ShowWatchProviderResult: Equatable, Decodable {
    let id: Int
    let results: [String: ShowWatchProvider]
}

public struct ShowWatchProvider: Equatable, Decodable {
    public let link: String
    public let free: [WatchProvider]?
    public let flatrate: [WatchProvider]?
    public let buy: [WatchProvider]?
    public let rent: [WatchProvider]?
}
