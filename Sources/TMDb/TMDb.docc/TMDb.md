# ``TMDb``

Millions of movies, TV series and people to discover. Explore now.

## Overview

![TMDb Logo.](tmdb_logo.svg)

The Movie Database (TMDB) is a community built movie and TV database. Every
piece of data has been added by their amazing community dating back to 2008.
TMDB's strong international focus and breadth of data is largely unmatched and
something they're' incredibly proud of. Put simply, they live and breathe
community and that's precisely what makes them different.

Every year since 2008, the number of contributions to their database has
increased. With over 1,000,000 developers and companies using their platform,
TMDB has become a premiere source for metadata.

Along with extensive metadata for movies, TV series and people, they also offer
one of the best selections of high resolution posters and fanart. On average,
over 1,000 images are added every single day.

They're international. While they officially support 39 languages they also
have extensive regional data. Every single day TMDB is used in over 180
countries.

Their community is second to none. Between their staff and community
moderators, they're always there to help. They're passionate about making sure
your experience on TMDB is nothing short of amazing.

Trusted platform. Every single day their service is used by millions of people
while we process over 3 billion requests. They've proven for years that this is
a service that can be trusted and relied on.

For the TMDb API documentation, see
[https://developer.themoviedb.org/docs](https://developer.themoviedb.org/docs).

This product uses the TMDb API but is not endorsed or certified by TMDb.

Watch providers provided by [JustWatch](https://www.justwatch.com).

## Topics

### Getting Started

- <doc:/CreatingTMDbClient>
- <doc:/CreatingTMDbAPIKey>
- ``TMDbClient``

### API Configuration

- <doc:/GeneratingImageURLs>

### Movies

- ``MovieService``
- ``Movie``
- ``AccountStates``
- ``ShowCredits``
- ``ReviewPageableList``
- ``Review``
- ``ImageCollection``
- ``VideoCollection``
- ``MovieExternalLinksCollection``
- ``MoviePageableList``
- ``MovieImageFilter``
- ``MovieVideoFilter``
- ``MovieReleaseDatesByCountry``
- ``ReleaseDate``
- ``ReleaseType``
- ``AlternativeTitle``
- ``AlternativeTitleCollection``
- ``Translation``
- ``TranslationCollection``
- ``MovieTranslationData``
- ``Change``
- ``ChangeItem``
- ``ChangeCollection``
- ``ChangedID``
- ``ChangedIDCollection``
- ``AnyCodable``

### TV Series

- ``TVSeriesService``
- ``TVSeries``
- ``TVSeriesPageableList``
- ``ShowCredits``
- ``TVSeriesAggregateCredits``
- ``AggregateCastMember``
- ``AggregateCrewMember``
- ``CastRole``
- ``CrewJob``
- ``ReviewPageableList``
- ``Review``
- ``ImageCollection``
- ``VideoCollection``
- ``TVSeriesExternalLinksCollection``
- ``TVSeriesImageFilter``
- ``TVSeriesVideoFilter``
- ``ContentRating``
- ``KeywordCollection``
- ``AlternativeTitleCollection``
- ``AlternativeTitle``
- ``TranslationCollection``
- ``Translation``
- ``TVSeriesTranslationData``
- ``ChangeCollection``
- ``Change``
- ``ChangeItem``
- ``AnyCodable``
- ``ChangedIDCollection``
- ``ChangedID``

### TV Seasons

- ``TVSeasonService``
- ``TVSeason``
- ``TVSeasonImageCollection``
- ``VideoCollection``
- ``TVSeasonImageFilter``
- ``TVSeasonVideoFilter``

### TV Episodes

- ``TVEpisodeService``
- ``TVEpisode``
- ``TVEpisodeImageCollection``
- ``VideoCollection``
- ``TVEpisodeImageFilter``
- ``TVEpisodeVideoFilter``

### People

- ``PersonService``
- ``Person``
- ``PersonCombinedCredits``
- ``PersonMovieCredits``
- ``PersonTVSeriesCredits``
- ``PersonImageCollection``
- ``Show``
- ``PersonExternalLinksCollection``
- ``PersonPageableList``

### Discover

- ``DiscoverService``
- ``MoviePageableList``
- ``Movie``
- ``MovieSort``
- ``DiscoverMovieFilter``
- ``TVSeriesPageableList``
- ``TVSeries``
- ``TVSeriesSort``
- ``DiscoverTVSeriesFilter``

### Trending

- ``TrendingService``
- ``MoviePageableList``
- ``Movie``
- ``TVSeriesPageableList``
- ``TVSeries``
- ``PersonPageableList``
- ``Person``
- ``TrendingTimeWindowFilterType``

### Search

- ``SearchService``
- ``MediaPageableList``
- ``Media``
- ``MoviePageableList``
- ``Movie``
- ``TVSeriesPageableList``
- ``TVSeries``
- ``PersonPageableList``
- ``Person``
- ``AllMediaSearchFilter``
- ``MovieSearchFilter``
- ``TVSeriesSearchFilter``
- ``PersonSearchFilter``

### Find

- ``FindService``
- ``FindResults``
- ``ExternalSource``

### Certifications

- ``CertificationService``
- ``Certification``

### Collections

- ``CollectionService``
- ``Collection``
- ``CollectionImageCollection``
- ``CollectionListItem``
- ``CollectionTranslation``
- ``CollectionTranslationData``

### Account States

- ``AccountStates``

### Companies

- ``CompanyService``
- ``Company``
- ``Company/Parent``

### Genres

- ``GenreService``
- ``Genre``

### Keywords

- ``KeywordService``
- ``Keyword``
- ``KeywordCollection``

### Networks

- ``NetworkService``
- ``Network``
- ``NetworkAlternativeName``
- ``NetworkLogo``

### Watch Providers

- ``WatchProviderService``
- ``WatchProvider``
- ``Country``
- ``WatchProviderFilter``

### Configuration

- ``ConfigurationService``
- ``APIConfiguration``
- ``ImagesConfiguration``
- ``Country``
- ``Department``
- ``Language``

### Account

- ``AccountService``
- ``AccountDetails``
- ``AccountAvatar``
- ``AccountAvatar/Gravatar``
- ``AccountAvatar/TMDb``
- ``FavouriteSort``
- ``WatchlistSort``
- ``RatedSort``
- ``MoviePageableList``
- ``Movie``
- ``TVSeriesPageableList``
- ``TVSeries``
- ``TVEpisodePageableList``
- ``TVEpisode``
- ``MediaListSummaryPageableList``
- ``MediaListSummary``

### Lists

- ``ListService``
- ``MediaList``
- ``MediaListItem``
- ``MediaListItemStatus``
- ``CreateListResult``

### Authentication

- ``AuthenticationService``
- ``GuestSession``
- ``Credential``
- ``Token``
- ``Session``

### Custom HTTP Client

- ``HTTPClient``
- ``HTTPRequest``
- ``HTTPResponse``
