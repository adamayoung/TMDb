//
//  File.swift
//  
//
//  Created by Kirill Emelyanenko on 9.10.23.
//

import Foundation

public struct MovieAvailability: Codable {
    public let id: Int
    public let results: [String: AvailabilityDetails]
}

public struct AvailabilityDetails: Codable {
    public let link: String?
    public let flatrate: [Provider]?
    public let buy: [Provider]?
    public let rent: [Provider]?
}

public struct Provider: Codable, Identifiable, Equatable {
    public var id: Int {
        get {
            providerId
        }
    }
    
    public let logoPath: String?
    public let providerId: Int
    public let providerName: String
    public let displayPriority: Int?
    
//    public enum CodingKeys: String, CodingKey {
//        case logoPath = "logo_path"
//        case providerId = "provider_id"
//        case providerName = "provider_name"
//        case displayPriority = "display_priority"
//    }
}

