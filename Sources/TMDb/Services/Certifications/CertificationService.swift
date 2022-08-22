import Foundation

/// A service to fetch an up to date list of the officially supported movie and TV show certifications on TMDb.
public protocol CertificationService: MovieCertificationService, TVShowCertificationService { }
