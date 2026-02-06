# ``MovieService``

## Topics

### Details

- ``details(forMovie:language:)``
- ``details(forMovie:appending:language:)``

### Credits

- ``credits(forMovie:language:)``

### Reviews

- ``reviews(forMovie:page:language:)``

### Media

- ``images(forMovie:filter:)``
- ``videos(forMovie:filter:)``

### User Interactions

- ``accountStates(forMovie:session:)``
- ``addRating(_:toMovie:session:)``
- ``deleteRating(forMovie:session:)``

### Auto-Pagination

- ``allPopular(country:language:)``
- ``allTopRated(country:language:)``
- ``allNowPlaying(country:language:)``
- ``allUpcoming(country:language:)``
- ``allRecommendations(forMovie:language:)``
- ``allSimilar(toMovie:language:)``
- ``allReviews(forMovie:language:)``
- ``allLists(forMovie:language:)``
- ``allPopularPages(country:language:)``
- ``allTopRatedPages(country:language:)``
- ``allNowPlayingPages(country:language:)``
- ``allUpcomingPages(country:language:)``
- ``allRecommendationsPages(forMovie:language:)``
- ``allSimilarPages(toMovie:language:)``
- ``allReviewsPages(forMovie:language:)``
- ``allListsPages(forMovie:language:)``

### Lists and Related Content

- ``recommendations(forMovie:page:language:)``
- ``similar(toMovie:page:language:)``
- ``lists(forMovie:page:language:)``
- ``nowPlaying(page:country:language:)``
- ``popular(page:country:language:)``
- ``topRated(page:country:language:)``
- ``upcoming(page:country:language:)``

### Content Discovery

- ``keywords(forMovie:)``
- ``alternativeTitles(forMovie:country:language:)``
- ``translations(forMovie:)``

### Change Tracking

- ``changes(forMovie:startDate:endDate:page:)``
- ``changes(startDate:endDate:page:)``
- ``latest()``

### Other

- ``releaseDates(forMovie:)``
- ``watchProviders(forMovie:)``
- ``externalLinks(forMovie:)``
