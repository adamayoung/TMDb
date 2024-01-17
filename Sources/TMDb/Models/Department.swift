//
//  Department.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing a department and jobs.
///
public struct Department: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Departments's identifier (same as `name`).
    ///
    public var id: String { name }

    ///
    /// Department's name.
    ///
    public let name: String

    ///
    /// List of jobs in this department.
    ///
    public let jobs: [String]

    ///
    /// Creates a department object.
    ///
    /// - Parameters:
    ///   - name: Department's name.
    ///   - jobs: List of jobs in this department.
    ///
    public init(name: String, jobs: [String]) {
        self.name = name
        self.jobs = jobs
    }

}

extension Department {

    private enum CodingKeys: String, CodingKey {
        case name = "department"
        case jobs
    }

}
