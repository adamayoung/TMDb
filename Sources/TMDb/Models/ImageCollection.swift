//
//  ImageCollection.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct ImageCollection: Decodable {

    public let id: Int
    public let posters: [ImageMetadata]
    public let backdrops: [ImageMetadata]

    public init(id: Int, posters: [ImageMetadata], backdrops: [ImageMetadata]) {
        self.id = id
        self.posters = posters
        self.backdrops = backdrops
    }

}
