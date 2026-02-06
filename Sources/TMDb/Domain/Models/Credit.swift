//
//  Credit.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a credit.
///
public struct Credit: Identifiable, Codable, Equatable, Hashable,
Sendable {

    ///
    /// Credit identifier.
    ///
    public let id: String

    ///
    /// Credit type.
    ///
    public let creditType: CreditType

    ///
    /// Credit department.
    ///
    public let department: String

    ///
    /// Credit job.
    ///
    public let job: String

    ///
    /// Media type.
    ///
    public let mediaType: String

    ///
    /// Media associated with the credit.
    ///
    public let media: CreditMedia

    ///
    /// Person associated with the credit.
    ///
    public let person: CreditPerson

    ///
    /// Creates a credit object.
    ///
    /// - Parameters:
    ///    - id: Credit identifier.
    ///    - creditType: Credit type.
    ///    - department: Credit department.
    ///    - job: Credit job.
    ///    - mediaType: Media type.
    ///    - media: Media associated with the credit.
    ///    - person: Person associated with the credit.
    ///
    public init(
        id: String,
        creditType: CreditType,
        department: String,
        job: String,
        mediaType: String,
        media: CreditMedia,
        person: CreditPerson
    ) {
        self.id = id
        self.creditType = creditType
        self.department = department
        self.job = job
        self.mediaType = mediaType
        self.media = media
        self.person = person
    }

}
