# Creating a TMDbClient

Instructions on how to setup TMDbClient.

## Overview

Create a ``TMDbClient`` to request data from TMDb.

## Creating a TMDb API Key

To create a configuration object you first need a TMDb API Key. See <doc:/CreatingTMDbAPIKey>.

## Creating TMDbClient

### Configuration with URLSession

To use `URLSession` to perform network tasks, create the ``TMDbClient``

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")
```

### Configuration with default language and country

Use ``TMDbConfiguration`` to set default language and country values that will
be applied to API requests when explicit values are not provided.

```swift
let configuration = TMDbConfiguration(
    defaultLanguage: "es-ES",
    defaultCountry: "ES"
)

let tmdbClient = TMDbClient(
    apiKey: "<your-tmdb-api-key>",
    configuration: configuration
)
```

Alternatively, use ``TMDbConfiguration/system`` to automatically use the
system's current locale settings.

```swift
let tmdbClient = TMDbClient(
    apiKey: "<your-tmdb-api-key>",
    configuration: .system
)
```

### Configuration with custom HTTP Client

TMDb can be configured with your own adapter to perform network tasks. It allows
you to use an HTTP client library such as
[``AsyncHTTPClient``](https://github.com/swift-server/async-http-client).

The adapter should conform to ``HTTPClient``.

```swift
class MyHTTPClient: HTTPClient {
    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        // Implement performing a network request.
    }
}
```

Then create `TMDbClient` using the adapter.

```swift
let customHTTPClient = MyHTTPClient()

let tmdbClient = TMDbClient(
    apiKey: "<your-tmdb-api-key>",
    httpClient: customHTTPClient
)
```

## Using TMDbClient

Once created, your instance of ``TMDbClient`` can be used to interact with the
TMDb API.

e.g. To discover movies and fetch details on a specific movie

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

let moviesToDiscover = try await tmdbClient.discover.movies().results
let fightClub = try await tmdbClient.movies.details(forMovie: 550)
```
