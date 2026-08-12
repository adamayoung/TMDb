# Generating Image URLs

Instructions on how to generate the full URL from an image path.

## Overview

TMDb returns paths to images in objects such as ``Movie``, ``TVSeries`` and
``Person``. In order to get the actual image the full URL needs to be
generated.

There are two ways to do this. Reach for ``TMDbClient/images`` for everyday
use; drop down to ``ImagesConfiguration`` when you are resolving many URLs at
once.

## Resolving a Single Image URL

``TMDbClient/images`` resolves an image path in one call. It fetches TMDb's
images configuration the first time it needs it and caches it for the lifetime
of the client, so you do not have to hold that object yourself.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

let barbieMovie = try await tmdbClient.movies.details(forMovie: 346698)

let barbiePosterURL = try await tmdbClient.images.posterURL(
    for: barbieMovie.posterPath,
    size: .width(500)
)
```

> Tip: Use `idealWidth` instead of `size` to ask for the best available image
for a width, rather than an exact size. Without either, you get the original
image.

A `nil` path returns `nil` without making a request, so a model with no image
costs nothing and never surfaces a network error.

### Warming the Cache

The first URL you resolve pays for fetching the configuration. Call
``ImageService/preload()`` at launch to pay that cost up front instead:

```swift
try await tmdbClient.images.preload()
```

The configuration is fetched **at most once**, however many callers ask for it
concurrently.

> Important: A caller that is **waiting** on the shared fetch when its task is
cancelled abandons the wait and throws ``TMDbError/cancelled``. The fetch itself
is never cancelled on that caller's behalf — it runs on, delivers to every other
caller waiting on it, and caches its result — because cancelling it for one
uninterested caller would fail all the others.
>
> A caller served from the **cache** never suspends, so it cannot observe the
cancellation and returns its URL as normal. Preloading therefore makes these
methods effectively cancellation-free.

## Resolving Many Image URLs

Every resolver method is `async`, so resolving a screenful of images means an
`await` apiece. When you have a batch, fetch the ``ImagesConfiguration`` once
and use its synchronous helpers directly:

```swift
let imagesConfiguration = try await tmdbClient.images.imagesConfiguration()

let posterURLs = movies.map { movie in
    imagesConfiguration.posterURL(for: movie.posterPath, size: .width(500))
}
```

This is the same cached configuration ``TMDbClient/images`` uses, so it costs
no extra request.

## Requesting a Specific Size

The size must be one of the sizes available in the ``ImagesConfiguration`` for
that image type (for example ``ImagesConfiguration/posterSizes``);
``ImageSize/original`` is always supported. If an unsupported size is
requested, `nil` is returned.

```swift
let barbiePosterURL = try await tmdbClient.images.posterURL(
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

Use the following methods on ``TMDbClient/images`` to generate image URLs
depending on the type of image needed:

* ``ImageService/backdropURL(for:idealWidth:)``
* ``ImageService/logoURL(for:idealWidth:)``
* ``ImageService/posterURL(for:idealWidth:)``
* ``ImageService/profileURL(for:idealWidth:)``
* ``ImageService/stillURL(for:idealWidth:)``

Or, to request a specific ``ImageSize``:

* ``ImageService/backdropURL(for:size:)``
* ``ImageService/logoURL(for:size:)``
* ``ImageService/posterURL(for:size:)``
* ``ImageService/profileURL(for:size:)``
* ``ImageService/stillURL(for:size:)``

The same ten methods exist on ``ImagesConfiguration`` in synchronous form, for
the batch case above.

## Keeping the Configuration Fresh

TMDb's images configuration changes rarely, so caching it for the lifetime of
the client is normally the right thing. A long-lived process that wants to pick
up a change can call ``ImageService/refresh()``:

```swift
try await tmdbClient.images.refresh()
```

The cached value is replaced only once a fresh one arrives, so a refresh that
fails leaves the previous configuration in place rather than leaving you with
none. Callers resolving image URLs during the refresh continue to use the
cached value instead of waiting.
