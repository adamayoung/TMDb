# ``TrendingService``

## Topics

### Movies

- ``movies()``
- ``movies(inTimeWindow:)``
- ``movies(page:)``
- ``movies(language:)``
- ``movies(inTimeWindow:page:)``
- ``movies(inTimeWindow:language:)``
- ``movies(page:language:)``
- ``movies(inTimeWindow:page:language:)``

### TV Series

- ``tvSeries()``
- ``tvSeries(inTimeWindow:)``
- ``tvSeries(page:)``
- ``tvSeries(language:)``
- ``tvSeries(inTimeWindow:page:)``
- ``tvSeries(inTimeWindow:language:)``
- ``tvSeries(page:language:)``
- ``tvSeries(inTimeWindow:page:language:)``

### People

- ``people()``
- ``people(inTimeWindow:)``
- ``people(page:)``
- ``people(language:)``
- ``people(inTimeWindow:page:)``
- ``people(inTimeWindow:language:)``
- ``people(page:language:)``
- ``people(inTimeWindow:page:language:)``

### All

- ``allTrending()``
- ``allTrending(inTimeWindow:)``
- ``allTrending(page:)``
- ``allTrending(language:)``
- ``allTrending(inTimeWindow:page:)``
- ``allTrending(inTimeWindow:language:)->TrendingPageableList``
- ``allTrending(page:language:)``
- ``allTrending(inTimeWindow:page:language:)``

### Auto-Pagination

- ``allMovies(inTimeWindow:language:)``
- ``allTVSeries(inTimeWindow:language:)``
- ``allPeople(inTimeWindow:language:)``
- ``allTrending(inTimeWindow:language:)->PagedAsyncSequence<TrendingItem>``
- ``allMoviesPages(inTimeWindow:language:)``
- ``allTVSeriesPages(inTimeWindow:language:)``
- ``allPeoplePages(inTimeWindow:language:)``
- ``allTrendingPages(inTimeWindow:language:)``
