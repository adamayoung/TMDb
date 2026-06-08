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

## Requesting a Specific Size

Instead of an ideal width, you can request a specific ``ImageSize`` such as a
fixed width, a fixed height, or the original image. The size must be one of the
sizes available in the ``ImagesConfiguration`` for that image type (for example
``ImagesConfiguration/posterSizes``); ``ImageSize/original`` is always
supported. If an unsupported size is requested, `nil` is returned.

```swift
let barbiePosterURL = imagesConfiguration.posterURL(
    for: barbieMovie.posterPath,
    size: .width(500)
)
```

## Convenience Accessors on Models

Many models conform to image-providing protocols
(``PosterImageProviding``, ``BackdropImageProviding``,
``ProfileImageProviding``, ``LogoImageProviding`` and
``StillImageProviding``), which expose convenience methods that take an
``ImagesConfiguration`` directly:

```swift
let posterURL = barbieMovie.posterURL(
    using: imagesConfiguration,
    size: .width(500)
)
```

## Image types

Use the following methods on ``ImagesConfiguration`` to generate image URLs
depending on the type of image needed:

* ``ImagesConfiguration/backdropURL(for:idealWidth:)``
* ``ImagesConfiguration/logoURL(for:idealWidth:)``
* ``ImagesConfiguration/posterURL(for:idealWidth:)``
* ``ImagesConfiguration/profileURL(for:idealWidth:)``
* ``ImagesConfiguration/stillURL(for:idealWidth:)``

Or, to request a specific ``ImageSize``:

* ``ImagesConfiguration/backdropURL(for:size:)``
* ``ImagesConfiguration/logoURL(for:size:)``
* ``ImagesConfiguration/posterURL(for:size:)``
* ``ImagesConfiguration/profileURL(for:size:)``
* ``ImagesConfiguration/stillURL(for:size:)``
