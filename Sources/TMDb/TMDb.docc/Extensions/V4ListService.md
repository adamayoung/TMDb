# ``V4ListService``

## Topics

### Reading a List

- ``details(forList:)``
- ``details(forList:accessToken:)``
- ``details(forList:page:sortedBy:language:accessToken:)``
- ``items(forList:)``
- ``items(forList:accessToken:)``
- ``items(forList:page:sortedBy:language:accessToken:)``

### Checking an Item

- ``itemStatus(forMedia:ofType:inList:)``
- ``itemStatus(forMedia:ofType:inList:accessToken:)``

### Listing an Account's Lists

- ``lists(forAccount:accessToken:)``
- ``lists(forAccount:page:accessToken:)``

### Creating and Updating a List

- ``create(name:accessToken:)``
- ``create(name:attributes:accessToken:)``
- ``update(list:name:accessToken:)``
- ``update(list:attributes:accessToken:)``

### Managing a List's Items

- ``addItems(_:toList:accessToken:)``
- ``updateItems(_:inList:accessToken:)``
- ``removeItems(_:fromList:accessToken:)``
- ``clear(list:accessToken:)``

### Deleting a List

- ``delete(list:accessToken:)``
