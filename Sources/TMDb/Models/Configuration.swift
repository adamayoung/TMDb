//
//  Configuration.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct Configuration: Decodable {

    public let images: ImagesConfiguration
    public let changeKeys: [String]

    public init(images: ImagesConfiguration, changeKeys: [String]) {
        self.images = images
        self.changeKeys = changeKeys
    }

}
