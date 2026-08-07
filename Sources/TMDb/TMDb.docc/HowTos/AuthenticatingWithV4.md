# Authenticating with the v4 API

Obtain a TMDb v4 user access token, and understand how it differs from a v3 session.

## Overview

TMDb exposes two authentication systems, and they are not interchangeable. The
v3 API authenticates with a *session*; the v4 API authenticates with an *access
token*. Which you need depends on the endpoint you are calling, not on a
preference.

This article covers the v4 flow. For v3 sessions, see
<doc:/ManagingUserAccounts>.

## Three credentials, three jobs

The most common source of confusion is that TMDb issues three different
credentials, two of which are shown on the same settings page.

| Credential | Where it comes from | What it authenticates |
| --- | --- | --- |
| API key | TMDb Settings → API | v3 endpoints, as an `api_key` query item |
| API Read Access Token | TMDb Settings → API | your *application*, as a bearer token |
| User access token | The flow below | a *user*, as a bearer token |

The API key and the API Read Access Token both identify your application, but
they are not the same string and are not accepted in the same places. In
particular, **the v4 authentication endpoints reject a v3 API key** — they
require a bearer credential. Create your client accordingly:

```swift
let client = TMDbClient(bearerToken: "<your API Read Access Token>")
```

A user access token is different again: it authorises actions *on behalf of a
signed-in TMDb user*, and only that user can grant it.

## The flow

Obtaining a user access token takes three steps, and the middle one requires a
human. There is no way to automate it — that is the point of it.

### 1. Create a request token

```swift
let requestToken = try await client.v4Authentication.requestToken()
```

A request token carries no authority on its own. It expires 15 minutes after it
is issued, so create it when you are ready to send the user to approve it, not
in advance.

### 2. Have the user approve it

```swift
let approvalURL = client.v4Authentication.authenticateURL(for: requestToken)
// Open `approvalURL` in a browser — e.g. ASWebAuthenticationSession on Apple
// platforms — and wait for the user to approve.
```

Pass a `redirectURL` to ``V4AuthenticationService/requestToken(redirectURL:)``
if you want TMDb to send the user back to your app after approving:

```swift
let requestToken = try await client.v4Authentication.requestToken(
    redirectURL: URL(string: "myapp://auth/callback")
)
```

### 3. Exchange it for an access token

```swift
let accessToken = try await client.v4Authentication.createAccessToken(
    withRequestToken: requestToken
)
```

Exchanging a token the user has not approved fails, so only call this once
approval has completed.

The result carries both the token and the account it belongs to:

```swift
accessToken.accessToken  // the credential
accessToken.accountID    // the v4 account object id — an opaque string
```

Note that `accountID` is *not* the integer account id used by v3. It is an
opaque object identifier, and the two are not interchangeable.

## Storing and revoking tokens

A user access token is long lived: it stays valid until it is revoked. Treat it
as a credential — store it in the keychain, never in user defaults, a plist, or
source control, and never log it.

To revoke one:

```swift
try await client.v4Authentication.deleteAccessToken(accessToken.accessToken)
```

Users can also revoke access from their TMDb account settings, so treat a
sudden authentication failure as a signal to discard the stored token and run
the flow again rather than as a bug.

## Using the token with v4 lists

The access token is what ``V4ListService`` needs. Reading a *public* list takes
no token at all:

```swift
let list = try await client.v4Lists.details(forList: 1)
```

Everything else — a private list, and every write — takes the user's token:

```swift
let token = accessToken.accessToken

let created = try await client.v4Lists.create(
    name: "Weekend Watchlist",
    attributes: V4ListAttributes(description: "Films to catch up on", isPublic: false),
    accessToken: token
)

// A v4 list holds movies and TV series together.
let added = try await client.v4Lists.addItems(
    [.movie(550), .tvSeries(1399)],
    toList: created.id,
    accessToken: token
)

// Check the per-item outcomes: TMDb reports overall success even when an
// individual item failed.
if !added.allItemsSucceeded {
    print("failed: \(added.failures)")
}
```

Comments are set separately. Adding an item with a comment attached does not
store it — only updating an existing item does:

```swift
try await client.v4Lists.updateItems(
    [.movie(550, comment: "Rewatch for the twist")],
    inList: created.id,
    accessToken: token
)
```

To list everything the user owns, use the `accountID` from the access token:

```swift
let lists = try await client.v4Lists.lists(
    forAccount: accessToken.accountID,
    accessToken: token
)
```

- Note: Responses to any of these are **never cached**, by either cache layer.
  They are private to one user, and a v4 list read carries its credential in a
  header rather than the URL — so two users' requests are otherwise
  indistinguishable. See <doc:CachingResponses>.

## Bridging to a v3 session

If you already hold a v4 user access token and need to call a v3 endpoint,
convert it rather than asking the user to authenticate twice:

```swift
let session = try await client.authentication.createSession(
    withV4AccessToken: accessToken.accessToken
)
```
