# ``AccountService``

## Topics

### Account Details

- ``details(session:)``

### Authenticated Session

- ``authenticatedSession(for:)``

### Favourite Movies

- ``favouriteMovies(sortedBy:page:authenticatedSession:)``
- ``favouriteMovies(sortedBy:page:accountID:session:)``
- ``addFavourite(movie:authenticatedSession:)``
- ``addFavourite(movie:accountID:session:)``
- ``removeFavourite(movie:authenticatedSession:)``
- ``removeFavourite(movie:accountID:session:)``

### Favourite TV Series

- ``favouriteTVSeries(sortedBy:page:authenticatedSession:)``
- ``favouriteTVSeries(sortedBy:page:accountID:session:)``
- ``addFavourite(tvSeries:authenticatedSession:)``
- ``addFavourite(tvSeries:accountID:session:)``
- ``removeFavourite(tvSeries:authenticatedSession:)``
- ``removeFavourite(tvSeries:accountID:session:)``

### Movie Watchlist

- ``movieWatchlist(sortedBy:page:authenticatedSession:)``
- ``movieWatchlist(sortedBy:page:accountID:session:)``
- ``addToWatchlist(movie:authenticatedSession:)``
- ``addToWatchlist(movie:accountID:session:)``
- ``removeFromWatchlist(movie:authenticatedSession:)``
- ``removeFromWatchlist(movie:accountID:session:)``

### TV Series Watchlist

- ``tvSeriesWatchlist(sortedBy:page:authenticatedSession:)``
- ``tvSeriesWatchlist(sortedBy:page:accountID:session:)``
- ``addToWatchlist(tvSeries:authenticatedSession:)``
- ``addToWatchlist(tvSeries:accountID:session:)``
- ``removeFromWatchlist(tvSeries:authenticatedSession:)``
- ``removeFromWatchlist(tvSeries:accountID:session:)``

### Rated Movies

- ``ratedMovies(sortedBy:page:authenticatedSession:)``
- ``ratedMovies(sortedBy:page:accountID:session:)``

### Rated TV Series

- ``ratedTVSeries(sortedBy:page:authenticatedSession:)``
- ``ratedTVSeries(sortedBy:page:accountID:session:)``

### Rated TV Episodes

- ``ratedTVEpisodes(sortedBy:page:authenticatedSession:)``
- ``ratedTVEpisodes(sortedBy:page:accountID:session:)``

### Custom Lists

- ``lists(page:authenticatedSession:)``
- ``lists(page:accountID:session:)``

### Auto-Pagination

- ``allFavouriteMovies(sortedBy:authenticatedSession:)``
- ``allFavouriteMovies(sortedBy:accountID:session:)``
- ``allFavouriteTVSeries(sortedBy:authenticatedSession:)``
- ``allFavouriteTVSeries(sortedBy:accountID:session:)``
- ``allWatchlistMovies(sortedBy:authenticatedSession:)``
- ``allWatchlistMovies(sortedBy:accountID:session:)``
- ``allWatchlistTVSeries(sortedBy:authenticatedSession:)``
- ``allWatchlistTVSeries(sortedBy:accountID:session:)``
- ``allRatedMovies(sortedBy:authenticatedSession:)``
- ``allRatedMovies(sortedBy:accountID:session:)``
- ``allRatedTVSeries(sortedBy:authenticatedSession:)``
- ``allRatedTVSeries(sortedBy:accountID:session:)``
- ``allRatedTVEpisodes(sortedBy:authenticatedSession:)``
- ``allRatedTVEpisodes(sortedBy:accountID:session:)``
- ``allLists(authenticatedSession:)``
- ``allLists(accountID:session:)``
- ``allFavouriteMoviesPages(sortedBy:authenticatedSession:)``
- ``allFavouriteMoviesPages(sortedBy:accountID:session:)``
- ``allFavouriteTVSeriesPages(sortedBy:authenticatedSession:)``
- ``allFavouriteTVSeriesPages(sortedBy:accountID:session:)``
- ``allWatchlistMoviesPages(sortedBy:authenticatedSession:)``
- ``allWatchlistMoviesPages(sortedBy:accountID:session:)``
- ``allWatchlistTVSeriesPages(sortedBy:authenticatedSession:)``
- ``allWatchlistTVSeriesPages(sortedBy:accountID:session:)``
- ``allRatedMoviesPages(sortedBy:authenticatedSession:)``
- ``allRatedMoviesPages(sortedBy:accountID:session:)``
- ``allRatedTVSeriesPages(sortedBy:authenticatedSession:)``
- ``allRatedTVSeriesPages(sortedBy:accountID:session:)``
- ``allRatedTVEpisodesPages(sortedBy:authenticatedSession:)``
- ``allRatedTVEpisodesPages(sortedBy:accountID:session:)``
- ``allListsPages(authenticatedSession:)``
- ``allListsPages(accountID:session:)``
