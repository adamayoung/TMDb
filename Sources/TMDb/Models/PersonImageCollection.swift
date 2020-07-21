//
//  PersonImageCollection.swift
//  TMDb
//
//  Created by Adam Young on 23/01/2020.
//

import Foundation

public struct PersonImageCollection: Identifiable, Decodable {

    public let id: Int
    public let profiles: [ImageMetadata]

}
