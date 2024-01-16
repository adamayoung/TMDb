FROM swift:5.9.2-jammy

WORKDIR /tmp

ADD Sources ./Sources
ADD Tests ./Tests
ADD Package.swift ./

CMD swift build --build-tests && swift test --skip-build --filter TMDbTests
