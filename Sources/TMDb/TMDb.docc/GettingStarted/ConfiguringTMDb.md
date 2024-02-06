# Configuring TMDb

Instructions on how to configure TMDb before using services.

## Overview

Before creating any of the TMDb services the configuration needs to be set.

## Creating the Configuration object

To create a configuration object you first need a TMDb API Key. See <doc:/CreatingTMDbAPIKey>.

### Configuration with URLSession

To use `URLSession` to perform network tasks, create a configuration object.

```swift
let tmdbConfiguration = TMDbConfiguration(apiKey: "<your-tmdb-api-key>")
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

Then create a TMDb configuration using the adapter.

```swift
let customHTTPClient = MyHTTPClient()

let tmdbConfiguration = TMDbConfiguration(
    apiKey: "<your-tmdb-api-key>",
    httpClient: customHTTPClient
)
```

## Setting the configuration

Once a configuration object has been created, configure TMDb with it.

```swift
TMDbConfiguration.configure(tmdbConfiguration)
```
