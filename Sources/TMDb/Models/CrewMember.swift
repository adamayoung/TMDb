//
//  CrewMember.swift
//  TMDb
//
//  Created by Adam Young on 29/01/2020.
//

import Foundation

public struct CrewMember: Identifiable, Decodable {

    public let id: Int
    public let creditID: String
    public let name: String
    public let job: String
    public let department: String
    public let gender: Gender?
    public let profilePath: URL?

    public init(id: Int, creditID: String, name: String, job: String, department: String, gender: Gender? = nil, profilePath: URL? = nil) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.job = job
        self.department = department
        self.gender = gender
        self.profilePath = profilePath
    }

}

extension CrewMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case creditID = "creditId"
        case name
        case job
        case department
        case gender
        case profilePath
    }

}
