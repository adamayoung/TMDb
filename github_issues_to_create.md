# GitHub Issues to Create for TMDb API Missing Features

Below are the GitHub issues that should be created for missing TMDb API features. Each issue is organized by priority and includes a title, labels, and detailed description.

---

## HIGH PRIORITY ISSUES

### Issue 1: Add Collections Service
**Labels:** `enhancement`, `high-priority`, `api-coverage`

**Description:**
Add support for TMDb Collections API endpoints to enable users to work with movie collections.

**Missing Endpoints:**
- `GET /collection/{collection_id}` - Get collection details
- `GET /collection/{collection_id}/images` - Get images for a collection
- `GET /collection/{collection_id}/translations` - Get translations for a collection

**Use Case:**
Collections are a core TMDb feature that group related movies together (e.g., "The Lord of the Rings Collection", "Marvel Cinematic Universe"). Users need to be able to fetch collection information and browse movies within a collection.

**Acceptance Criteria:**
- [ ] Create `CollectionService` protocol
- [ ] Implement `TMDbCollectionService` with all collection endpoints
- [ ] Add `Collection` model with appropriate properties
- [ ] Add unit tests for service methods
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 2: Add Movie Alternative Titles, Keywords, and Release Dates Endpoints
**Labels:** `enhancement`, `high-priority`, `movies`, `api-coverage`

**Description:**
Add support for additional movie metadata endpoints that are commonly needed for comprehensive movie information.

**Missing Endpoints:**
- `GET /movie/{movie_id}/alternative_titles` - Get alternative titles for a movie
- `GET /movie/{movie_id}/keywords` - Get the keywords for a movie  
- `GET /movie/{movie_id}/release_dates` - Get the release dates and certifications for a movie
- `GET /movie/{movie_id}/translations` - Get the translations for a movie

**Use Case:**
- Alternative titles help users find movies in different regions/languages
- Keywords enable better search and categorization
- Release dates show regional release information and certifications
- Translations provide localized movie data

**Acceptance Criteria:**
- [ ] Add methods to `MovieService` protocol
- [ ] Implement endpoints in `TMDbMovieService`
- [ ] Add appropriate model types (`AlternativeTitle`, `Keyword`, `ReleaseDate`, etc.)
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 3: Add Missing TV Series List Endpoints (Airing Today, On The Air, Top Rated)
**Labels:** `enhancement`, `high-priority`, `tv-series`, `api-coverage`

**Description:**
Add support for additional TV series list endpoints that are essential for TV content discovery.

**Missing Endpoints:**
- `GET /tv/airing_today` - Get a list of TV series airing today
- `GET /tv/on_the_air` - Get a list of TV series currently on the air
- `GET /tv/top_rated` - Get a list of top rated TV series

**Use Case:**
These lists are commonly used in applications to help users discover:
- What's airing today
- What shows are currently running
- The highest-rated TV series

**Acceptance Criteria:**
- [ ] Add methods to `TVSeriesService` protocol
- [ ] Implement endpoints in `TMDbTVSeriesService`
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 4: Add Find Service for External ID Lookups
**Labels:** `enhancement`, `high-priority`, `api-coverage`

**Description:**
Add a new FindService to enable looking up movies, TV series, and people by external IDs like IMDb ID, TVDB ID, etc.

**Missing Endpoints:**
- `GET /find/{external_id}` - Find content by external ID

**Supported External Sources:**
- IMDb ID
- TVDB ID
- TVRage ID
- Facebook ID
- Twitter ID
- Instagram ID

**Use Case:**
Many applications need to link TMDb content with other databases. The Find service is crucial for:
- Linking content from IMDb
- Syncing with TV tracking apps (TVDB)
- Cross-referencing with social media

**Acceptance Criteria:**
- [ ] Create `FindService` protocol
- [ ] Implement `TMDbFindService`
- [ ] Add `ExternalSource` enum for supported ID types
- [ ] Add `FindResult` model
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include find service
- [ ] Update documentation

---

### Issue 5: Add Account Rated Items Endpoints
**Labels:** `enhancement`, `high-priority`, `account`, `api-coverage`

**Description:**
Add support for fetching rated items from user accounts.

**Missing Endpoints:**
- `GET /account/{account_id}/rated/movies` - Get the movies rated by an account
- `GET /account/{account_id}/rated/tv` - Get the TV series rated by an account
- `GET /account/{account_id}/rated/tv/episodes` - Get the TV episodes rated by an account

**Use Case:**
Users want to see what they've rated to:
- Track their viewing history
- Review their ratings
- Export their data

**Acceptance Criteria:**
- [ ] Add methods to `AccountService` protocol
- [ ] Implement endpoints in `TMDbAccountService`
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 6: Add Rating Endpoints for Movies, TV Series, and Episodes
**Labels:** `enhancement`, `high-priority`, `api-coverage`

**Description:**
Add support for rating content (movies, TV series, episodes) and deleting ratings.

**Missing Endpoints:**

**Movies:**
- `POST /movie/{movie_id}/rating` - Rate a movie
- `DELETE /movie/{movie_id}/rating` - Delete a movie rating

**TV Series:**
- `POST /tv/{series_id}/rating` - Rate a TV series
- `DELETE /tv/{series_id}/rating` - Delete a TV series rating

**TV Episodes:**
- `POST /tv/{series_id}/season/{season_number}/episode/{episode_number}/rating` - Rate a TV episode
- `DELETE /tv/{series_id}/season/{season_number}/episode/{episode_number}/rating` - Delete a TV episode rating

**Use Case:**
Allow users to rate content directly from the application, which is a fundamental feature for tracking preferences and recommendations.

**Acceptance Criteria:**
- [ ] Add rating methods to `MovieService`, `TVSeriesService`, and `TVEpisodeService` protocols
- [ ] Implement rating endpoints in respective service implementations
- [ ] Add `Rating` model if needed
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

## MEDIUM PRIORITY ISSUES

### Issue 7: Add Keywords Service
**Labels:** `enhancement`, `medium-priority`, `api-coverage`

**Description:**
Add a new KeywordsService to enable working with TMDb keywords.

**Missing Endpoints:**
- `GET /keyword/{keyword_id}` - Get keyword details
- `GET /keyword/{keyword_id}/movies` - Get movies for a keyword

**Use Case:**
Keywords help with content discovery and categorization. Users can browse movies by specific keywords (e.g., "time travel", "superhero").

**Acceptance Criteria:**
- [ ] Create `KeywordsService` protocol
- [ ] Implement `TMDbKeywordsService`
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include keywords service
- [ ] Update documentation

---

### Issue 8: Add Reviews Service
**Labels:** `enhancement`, `medium-priority`, `api-coverage`

**Description:**
Add a new ReviewsService to get detailed information about individual reviews.

**Missing Endpoints:**
- `GET /review/{review_id}` - Get review details

**Use Case:**
When displaying a review, users may want to link to the full review details page or fetch additional review metadata.

**Acceptance Criteria:**
- [ ] Create `ReviewsService` protocol
- [ ] Implement `TMDbReviewsService`
- [ ] Reuse existing `Review` model or extend if needed
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include reviews service
- [ ] Update documentation

---

### Issue 9: Add Networks Service
**Labels:** `enhancement`, `medium-priority`, `tv-series`, `api-coverage`

**Description:**
Add a new NetworksService to enable working with TV networks.

**Missing Endpoints:**
- `GET /network/{network_id}` - Get network details
- `GET /network/{network_id}/alternative_names` - Get alternative names for a network
- `GET /network/{network_id}/images` - Get images for a network

**Use Case:**
Users can browse content by network (e.g., all Netflix shows, HBO shows) and get network-specific information.

**Acceptance Criteria:**
- [ ] Create `NetworksService` protocol
- [ ] Implement `TMDbNetworksService`
- [ ] Extend existing `Network` model with additional properties
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include networks service
- [ ] Update documentation

---

### Issue 10: Add TV Episode Credits Endpoint
**Labels:** `enhancement`, `medium-priority`, `tv-series`, `api-coverage`

**Description:**
Add support for fetching cast and crew credits for individual TV episodes.

**Missing Endpoints:**
- `GET /tv/{series_id}/season/{season_number}/episode/{episode_number}/credits` - Get the credits for a TV episode

**Use Case:**
Episodes often have guest stars and different crew members. Users want to see who appeared in or worked on specific episodes.

**Acceptance Criteria:**
- [ ] Add method to `TVEpisodeService` protocol
- [ ] Implement endpoint in `TMDbTVEpisodeService`
- [ ] Reuse existing `ShowCredits` model or create episode-specific variant
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 11: Add Search Collections and Companies Endpoints
**Labels:** `enhancement`, `medium-priority`, `search`, `api-coverage`

**Description:**
Extend search functionality to include collections and companies.

**Missing Endpoints:**
- `GET /search/collection` - Search for collections
- `GET /search/company` - Search for companies

**Use Case:**
Users want to search for:
- Movie collections by name (e.g., "Star Wars")
- Production companies (e.g., "Marvel Studios")

**Acceptance Criteria:**
- [ ] Add methods to `SearchService` protocol
- [ ] Implement endpoints in `TMDbSearchService`
- [ ] Add appropriate filter models if needed
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 12: Add Changes Endpoints for Movies, TV Series, Seasons, Episodes, and People
**Labels:** `enhancement`, `medium-priority`, `api-coverage`

**Description:**
Add support for tracking changes to content over time.

**Missing Endpoints:**

**Movies:**
- `GET /movie/changes` - Get a list of movie IDs that have been changed
- `GET /movie/{movie_id}/changes` - Get the changes for a movie

**TV Series:**
- `GET /tv/changes` - Get a list of TV series IDs that have been changed
- `GET /tv/{series_id}/changes` - Get the changes for a TV series

**TV Seasons:**
- `GET /tv/{series_id}/season/{season_number}/changes` - Get the changes for a TV season

**TV Episodes:**
- `GET /tv/{series_id}/season/{season_number}/episode/{episode_number}/changes` - Get the changes for a TV episode

**People:**
- `GET /person/changes` - Get a list of person IDs that have been changed
- `GET /person/{person_id}/changes` - Get the changes for a person

**Use Case:**
Applications that cache TMDb data need to know when content has been updated so they can refresh their local data.

**Acceptance Criteria:**
- [ ] Add methods to respective service protocols
- [ ] Implement endpoints in service implementations
- [ ] Add `Change` and related models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 13: Add Translations Endpoints for Movies, TV Series, Seasons, Episodes, and People
**Labels:** `enhancement`, `medium-priority`, `api-coverage`, `i18n`

**Description:**
Add support for fetching translations/localized data for content.

**Missing Endpoints:**

**Movies:**
- `GET /movie/{movie_id}/translations` - Get the translations for a movie

**TV Series:**
- `GET /tv/{series_id}/translations` - Get the translations for a TV series

**TV Seasons:**
- `GET /tv/{series_id}/season/{season_number}/translations` - Get the translations for a TV season

**TV Episodes:**
- `GET /tv/{series_id}/season/{season_number}/episode/{episode_number}/translations` - Get the translations for a TV episode

**People:**
- `GET /person/{person_id}/translations` - Get the translations for a person

**Collections:**
- `GET /collection/{collection_id}/translations` - Get translations for a collection

**Use Case:**
Multi-language applications need access to all available translations to display content in users' preferred languages.

**Acceptance Criteria:**
- [ ] Add methods to respective service protocols
- [ ] Implement endpoints in service implementations
- [ ] Add `Translation` model
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

## LOWER PRIORITY ISSUES

### Issue 14: Add Lists Service (V3 and V4 APIs)
**Labels:** `enhancement`, `low-priority`, `api-coverage`

**Description:**
Add a new ListsService to enable users to create and manage custom lists of movies.

**Missing Endpoints (V3):**
- `GET /list/{list_id}` - Get list details
- `POST /list` - Create a list
- `POST /list/{list_id}/add_item` - Add a movie to a list
- `POST /list/{list_id}/remove_item` - Remove a movie from a list
- `POST /list/{list_id}/clear` - Clear a list
- `DELETE /list/{list_id}` - Delete a list

**Missing Endpoints (V4):**
- `GET /list/{list_id}` - Get list details
- `POST /list` - Create a list
- `PUT /list/{list_id}` - Update a list
- `DELETE /list/{list_id}` - Delete a list
- `POST /list/{list_id}/items` - Add items to a list
- `DELETE /list/{list_id}/items` - Remove items from a list
- `PUT /list/{list_id}/items` - Update items in a list
- `POST /list/{list_id}/clear` - Clear a list

**Use Case:**
Power users want to create and manage custom lists of movies (e.g., "Movies to Watch", "Favorite Sci-Fi").

**Acceptance Criteria:**
- [ ] Create `ListsService` protocol
- [ ] Implement `TMDbListsService` for V3 API
- [ ] Consider V4 API implementation
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include lists service
- [ ] Update documentation

---

### Issue 15: Add Episode Groups Service
**Labels:** `enhancement`, `low-priority`, `tv-series`, `api-coverage`

**Description:**
Add a new EpisodeGroupsService to work with alternative TV episode groupings.

**Missing Endpoints:**
- `GET /tv/episode_group/{id}` - Get episode group details

**Use Case:**
Some TV series have alternative orderings (e.g., chronological order vs. broadcast order, director's cuts). Episode groups provide these alternative viewing orders.

**Acceptance Criteria:**
- [ ] Create `EpisodeGroupsService` protocol
- [ ] Implement `TMDbEpisodeGroupsService`
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include episode groups service
- [ ] Update documentation

---

### Issue 16: Add Latest Endpoints for Movies, TV Series, and People
**Labels:** `enhancement`, `low-priority`, `api-coverage`

**Description:**
Add support for fetching the most recently added content.

**Missing Endpoints:**
- `GET /movie/latest` - Get the latest movie
- `GET /tv/latest` - Get the latest TV series
- `GET /person/latest` - Get the latest person

**Use Case:**
Show users the newest content added to TMDb.

**Acceptance Criteria:**
- [ ] Add methods to respective service protocols
- [ ] Implement endpoints in service implementations
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 17: Add Account States Endpoints
**Labels:** `enhancement`, `low-priority`, `account`, `api-coverage`

**Description:**
Add support for fetching account states (favorite, rated, watchlist status) for individual content items.

**Missing Endpoints:**
- `GET /movie/{movie_id}/account_states` - Get the account states for a movie
- `GET /tv/{series_id}/account_states` - Get the account states for a TV series
- `GET /tv/{series_id}/season/{season_number}/account_states` - Get the account states for episodes in a season
- `GET /tv/{series_id}/season/{season_number}/episode/{episode_number}/account_states` - Get the account states for an episode

**Use Case:**
When displaying content, show whether the user has favorited, rated, or added it to their watchlist.

**Acceptance Criteria:**
- [ ] Add methods to respective service protocols
- [ ] Implement endpoints in service implementations
- [ ] Add `AccountStates` model
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 18: Add V4 Authentication Support
**Labels:** `enhancement`, `low-priority`, `authentication`, `api-coverage`

**Description:**
Add support for TMDb API v4 authentication flow.

**Missing Endpoints:**
- `POST /auth/request_token` - Create a request token (V4)
- `POST /auth/access_token` - Create an access token (V4)
- `DELETE /auth/access_token` - Delete an access token (V4)

**Use Case:**
The V4 auth flow provides a more modern OAuth-like authentication mechanism. This is needed for applications that want to use the latest authentication method.

**Acceptance Criteria:**
- [ ] Extend `AuthenticationService` protocol with V4 methods
- [ ] Implement V4 auth endpoints in `TMDbAuthenticationService`
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation with V4 auth flow

---

### Issue 19: Add Tagged Images Endpoint for People
**Labels:** `enhancement`, `low-priority`, `people`, `api-coverage`

**Description:**
Add support for fetching images where a person is tagged.

**Missing Endpoints:**
- `GET /person/{person_id}/tagged_images` - Get the tagged images for a person

**Use Case:**
Show all images from movies/TV shows where a person appears, even if they're not the primary subject.

**Acceptance Criteria:**
- [ ] Add method to `PersonService` protocol
- [ ] Implement endpoint in `TMDbPersonService`
- [ ] Reuse or extend image models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 20: Add Credit Service
**Labels:** `enhancement`, `low-priority`, `api-coverage`

**Description:**
Add a new CreditService to get detailed information about individual credits.

**Missing Endpoints:**
- `GET /credit/{credit_id}` - Get credit details (for both cast and crew)

**Use Case:**
Get detailed information about a specific credit, including the person, media, and role.

**Acceptance Criteria:**
- [ ] Create `CreditService` protocol
- [ ] Implement `TMDbCreditService`
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update `TMDbClient` to include credit service
- [ ] Update documentation

---

### Issue 21: Add Missing TV Series Additional Endpoints
**Labels:** `enhancement`, `low-priority`, `tv-series`, `api-coverage`

**Description:**
Add remaining TV series metadata endpoints.

**Missing Endpoints:**
- `GET /tv/{series_id}/alternative_titles` - Get alternative titles for a TV series
- `GET /tv/{series_id}/keywords` - Get the keywords for a TV series
- `GET /tv/{series_id}/episode_groups` - Get the episode groups for a TV series
- `GET /tv/{series_id}/screened_theatrically` - Get the seasons and episodes that have been screened theatrically

**Use Case:**
Provide comprehensive TV series metadata similar to what's available for movies.

**Acceptance Criteria:**
- [ ] Add methods to `TVSeriesService` protocol
- [ ] Implement endpoints in `TMDbTVSeriesService`
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 22: Add External IDs for TV Episodes
**Labels:** `enhancement`, `low-priority`, `tv-series`, `api-coverage`

**Description:**
Add support for fetching external IDs for TV episodes.

**Missing Endpoints:**
- `GET /tv/{series_id}/season/{season_number}/episode/{episode_number}/external_ids` - Get external IDs for an episode

**Use Case:**
Link episode data with external databases like IMDb and TVDB.

**Acceptance Criteria:**
- [ ] Add method to `TVEpisodeService` protocol
- [ ] Implement endpoint in `TMDbTVEpisodeService`
- [ ] Add appropriate models or reuse existing external links models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 23: Add Account Lists Endpoint
**Labels:** `enhancement`, `low-priority`, `account`, `api-coverage`

**Description:**
Add support for fetching lists created by an account.

**Missing Endpoints:**
- `GET /account/{account_id}/lists` - Get the lists created by an account

**Use Case:**
Show all custom lists created by a user.

**Acceptance Criteria:**
- [ ] Add method to `AccountService` protocol
- [ ] Implement endpoint in `TMDbAccountService`
- [ ] Add appropriate models
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

### Issue 24: Add Search Keywords Endpoint
**Labels:** `enhancement`, `low-priority`, `search`, `api-coverage`

**Description:**
Add support for searching keywords.

**Missing Endpoints:**
- `GET /search/keyword` - Search for keywords

**Use Case:**
Users can search for keywords to find related movies (e.g., search for "time travel" keyword).

**Acceptance Criteria:**
- [ ] Add method to `SearchService` protocol
- [ ] Implement endpoint in `TMDbSearchService`
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Update documentation

---

## Summary Statistics

**Total Missing Features: 24 issues**
- High Priority: 6 issues
- Medium Priority: 7 issues
- Low Priority: 11 issues

**Missing Services: 7 new services needed**
1. CollectionsService
2. FindService
3. KeywordsService
4. ReviewsService
5. NetworksService
6. ListsService
7. EpisodeGroupsService
8. CreditService

**Endpoints to Add to Existing Services:**
- MovieService: ~10 endpoints
- TVSeriesService: ~12 endpoints
- TVSeasonService: ~3 endpoints
- TVEpisodeService: ~6 endpoints
- PersonService: ~4 endpoints
- AccountService: ~5 endpoints
- SearchService: ~3 endpoints
- AuthenticationService: ~3 endpoints (V4)
