# Managing User Accounts

Work with user favorites, watchlists, and ratings.

## Overview

The ``AccountService`` provides access to user account features
including favorites, watchlists, and rated items. These features require
an authenticated session. Access it through the ``TMDbClient/account``
property.

## Authentication

Before using account features, create a session using the
``AuthenticationService``.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

// Create a request token
let token = try await tmdbClient.authentication.requestToken()

// Get the authentication URL for the user to approve the token
let authURL = tmdbClient.authentication.authenticateURL(
    for: token
)
// Present authURL to the user in a browser...

// After the user approves, create a session
let session = try await tmdbClient.authentication.createSession(
    withToken: token
)
```

## Managing Favorites

Add and remove movies and TV series from the user's favorites.

```swift
// Add a movie to favorites
try await tmdbClient.account.addFavourite(
    movie: 550,
    accountID: accountID,
    session: session
)

// Get favorite movies
let favouriteMovies = try await tmdbClient.account.favouriteMovies(
    accountID: accountID,
    session: session
)

// Remove from favorites
try await tmdbClient.account.removeFavourite(
    movie: 550,
    accountID: accountID,
    session: session
)
```

## Managing Watchlists

```swift
// Add a movie to watchlist
try await tmdbClient.account.addToWatchlist(
    movie: 550,
    accountID: accountID,
    session: session
)

// Get movie watchlist
let watchlist = try await tmdbClient.account.movieWatchlist(
    accountID: accountID,
    session: session
)

// Remove from watchlist
try await tmdbClient.account.removeFromWatchlist(
    movie: 550,
    accountID: accountID,
    session: session
)
```

## Rating Movies

```swift
// Rate a movie
try await tmdbClient.movies.addRating(
    8.5,
    toMovie: 550,
    session: session
)

// Get rated movies
let ratedMovies = try await tmdbClient.account.ratedMovies(
    accountID: accountID,
    session: session
)

// Delete a rating
try await tmdbClient.movies.deleteRating(
    forMovie: 550,
    session: session
)
```
