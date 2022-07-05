import Foundation

/// Department with Jobs.
public struct Department: Identifiable, Decodable, Equatable, Hashable {

    /// Departments's identifier (same as `name`).
    public var id: String { name }
    /// Department's name.
    public let name: String
    /// List of jobs in this department.
    public let jobs: [String]

    /// Creates a new `Department`.
    ///
    /// - Parameters:
    ///   - name: Department's name.
    ///   - jobs: List of jobs in this department.
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
