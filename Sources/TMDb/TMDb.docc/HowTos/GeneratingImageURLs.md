# Generating Image URLs

Instructions on how to generate the full URL from an image path.

## Overview

TMDb returns paths to images in objects such as ``Movie``, ``TVSeries`` and
``Person``. In order to get the actual image the full URL needs to be
generated.

## Fetching Images Configuration

Before an image's full URL can be generated from its path, the
``ImagesConfiguration`` needs to be fetched from TMDb using your
``TMDbClient`` instance.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

let apiConfiguration = try await tmdbClient.configurations.apiConfiguration()
let imagesConfiguration = apiConfiguration.images
```

## Generate the Image URL

Once you have the ``ImagesConfiguration`` it can be used to generate the full
URL to an image.

```swift
let barbieMovie = try await tmdbClient.movies.details(forMovie: 346698)

let barbiePosterURL = imagesConfiguration.posterURL(
    for: barbieMovie.posterPath
)
```

> Tip: You can add the `idealWidth` parameter to generate the URL for the image
best suited to a width. If `idealWidth` is not given, the URL to the original
image will be generated.

## Image types

Use the following methods on ``ImagesConfiguration`` to generate image URLs
depending on the type of image needed:

* ``ImagesConfiguration/backdropURL(for:idealWidth:)``
* ``ImagesConfiguration/logoURL(for:idealWidth:)``
* ``ImagesConfiguration/posterURL(for:idealWidth:)``
* ``ImagesConfiguration/profileURL(for:idealWidth:)``
* ``ImagesConfiguration/stillURL(for:idealWidth:)``
