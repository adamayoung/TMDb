# Using Language Model Tools

Build a conversational movie assistant with Apple's Foundation Models framework.

## Overview

``TMDbToolbox`` exposes TMDb as a set of Foundation Models `Tool`s, so a
`LanguageModelSession` can answer movie and TV questions by calling TMDb on your
behalf. The model decides which tools to call; the tools fetch and format the data.

The toolbox is available on devices with the Foundation Models framework — iOS 26,
macOS 26, visionOS 26, and watchOS 27. It is unavailable on tvOS, Linux, and
Windows.

## Adding the Tools to a Session

Pass ``TMDbClient/languageModelTools`` to a session to make every tool available:

```swift
import FoundationModels
import TMDb

let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

let session = LanguageModelSession(tools: tmdbClient.languageModelTools)
let reply = try await session.respond(to: "What's trending?")
print(reply.content)
```

Each tool returns compact text whose every line leads with the relevant TMDb
`id`, so the model can chain calls — searching for a title, then fetching its
details or watch providers.

## Choosing a Subset of Tools

Apple recommends keeping to three to five tools per request. Construct a
``TMDbToolbox`` and pass only the tools a task needs:

```swift
let toolbox = TMDbToolbox(client: tmdbClient, region: "GB")

let session = LanguageModelSession(
    tools: [toolbox.search, toolbox.discoverMovies, toolbox.watchProviders]
)
let reply = try await session.respond(to: "A thriller on Netflix?")
```

The `language` and `region` you pass to ``TMDbToolbox/init(client:language:region:)``
are applied to every tool's results — `region` drives watch-provider and
streaming-availability lookups.

Each tool is also available directly on the client when you don't need a default
language or region — for example ``TMDbClient/searchTool`` and
``TMDbClient/watchProvidersTool``:

```swift
let session = LanguageModelSession(
    tools: [tmdbClient.searchTool, tmdbClient.watchProvidersTool]
)
```

## Checking Availability

The tools run wherever the framework is present, but the model you attach to a
session may not be ready. Check the availability of the model you intend to
use — for example the on-device model — before starting a session:

```swift
switch SystemLanguageModel.default.availability {
case .available:
    let session = LanguageModelSession(tools: tmdbClient.languageModelTools)
    // ...

case .unavailable(let reason):
    print("Foundation model unavailable: \(reason)")
}
```
