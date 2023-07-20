# Creating a Service

Instructions on how to create a service to to fetch data from TMDb. 

## Overview

Creating any of the TMDb services requires a creating a configuration object and passing that to the service.

## Creating the Configuration object

To create a configuration object you first need a TMDb API Key. See <doc:/CreatingTMDbAPIKey>.

```swift
let tmdbConfiguration = TMDbConfiguration(apiKey: "<your-tmdb-api-key>")
```

## Creating a Service

Once a configuration is created, use it when creating a service.

```swift
let movieService = MovieService(config: tmdbConfiguration)
```
