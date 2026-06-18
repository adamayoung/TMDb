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

## Creating an Authenticated Session

Favorites, watchlists, and rated-item requests need both the user's account
ID and their session. Bundle them once into an ``AuthenticatedSession`` and
pass that single value to every account call.

```swift
// Performs a network request and throws TMDbError.
let authenticatedSession = try await tmdbClient.account
    .authenticatedSession(for: session)
```

> If you already hold the account ID, construct one directly with
> ``AuthenticatedSession/init(accountID:session:)`` — no network request.

## Managing Favorites

Add and remove movies and TV series from the user's favorites.

```swift
// Add a movie to favorites
try await tmdbClient.account.addFavourite(
    movie: 550,
    authenticatedSession: authenticatedSession
)

// Get favorite movies
let favouriteMovies = try await tmdbClient.account.favouriteMovies(
    authenticatedSession: authenticatedSession
)

// Remove from favorites
try await tmdbClient.account.removeFavourite(
    movie: 550,
    authenticatedSession: authenticatedSession
)
```

## Managing Watchlists

```swift
// Add a movie to watchlist
try await tmdbClient.account.addToWatchlist(
    movie: 550,
    authenticatedSession: authenticatedSession
)

// Get movie watchlist
let watchlist = try await tmdbClient.account.movieWatchlist(
    authenticatedSession: authenticatedSession
)

// Remove from watchlist
try await tmdbClient.account.removeFromWatchlist(
    movie: 550,
    authenticatedSession: authenticatedSession
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
    authenticatedSession: authenticatedSession
)

// Delete a rating
try await tmdbClient.movies.deleteRating(
    forMovie: 550,
    session: session
)
```
