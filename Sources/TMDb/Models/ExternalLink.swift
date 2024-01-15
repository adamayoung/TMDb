import Foundation

///
/// An interface for an external link.
///
/// e.g. to a Movie's IMDb page.
///
public protocol ExternalLink: Equatable, Hashable {

    ///
    /// The external site's item identifier.
    ///
    var id: String { get }

    ///
    /// The URL of the external site's item page.
    ///
    var url: URL { get }

}
