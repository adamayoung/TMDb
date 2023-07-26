import Foundation

///
/// Provides an interface to set up TMDb.
///
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public final class TMDb {

    static private(set) var configuration = TMDbConfiguration(
        apiKey: {
            preconditionFailure("Configuration must first be set by calling TMDb.configure(_:).")
        },
        httpClient: {
            preconditionFailure("Configuration must first be set by calling TMDb.configure(_:).")
        }
    )

    private init() { }

    ///
    /// Sets the configuration to be used with TMDb services.
    ///
    /// - Parameters:
    ///    - configuration: A TMDb configuration object.
    ///
    public static func configure(_ configuration: TMDbConfiguration) {
        Self.configuration = configuration
    }

}
