import Foundation

///
/// An interface for an external link.
///
/// e.g. to a Movie's IMDb page.
///
public protocol ExternalLink: Equatable {

    ///
    /// The external site's identifier.
    ///
    var id: String { get }

    ///
    /// The URL of the external site's page.
    ///
    var url: URL { get }

}
