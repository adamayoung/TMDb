import Foundation

/// A service to fetch information about people.
public protocol PersonService: PersonDetailsService, PersonCreditsService, PersonImageryService, PersonListsService { }
