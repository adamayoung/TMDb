import Foundation

extension URL {

    func appendingPathComponent(_ value: Int) -> Self {
        appendingPathComponent(String(value))
    }

    func appendingQueryItem(name: String, value: CustomStringConvertible) -> Self {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value.description))
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }

}

extension URL {

    private enum QueryItemName {
        static let apiKey = "api_key"
        static let language = "language"
		static let imageLanguage = "include_image_language"
		static let videoLanguage = "include_video_language"
        static let page = "page"
        static let year = "year"
        static let firstAirDateYear = "first_air_date_year"
        static let withPeople = "with_people"
    }

    func appendingAPIKey(_ apiKey: String) -> Self {
        appendingQueryItem(name: QueryItemName.apiKey, value: apiKey)
    }

    func appendingLanguage(locale: Locale = .current) -> Self {
        guard let languageCode = locale.languageCode else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.language, value: languageCode)
    }

	func appendingImageLanguage(local: Locale = .current) -> Self {
		guard let languageCode = locale.languageCode else {
			return self
		}

		return appendingQueryItem(name: QueryItemName.imageLanguage, value: languageCode.append(",null"))
	}
	
	func appendingVideoLanguage(local: Locale = .current) -> Self {
		guard let languageCode = locale.languageCode else {
			return self
		}

		return appendingQueryItem(name: QueryItemName.videoLanguage, value: languageCode.append(",null"))
	}
	
    func appendingPage(_ page: Int?) -> Self {
        guard var page = page else {
            return self
        }

        page = max(page, 1)
        page = min(page, 1000)

        return appendingQueryItem(name: QueryItemName.page, value: page)
    }

    func appendingYear(_ year: Int?) -> Self {
        guard let year = year else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.year, value: year)
    }

    func appendingFirstAirDateYear(_ year: Int?) -> Self {
        guard let year = year else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.firstAirDateYear, value: year)
    }

    func appendingWithPeople(_ people: [Person.ID]?) -> Self {
        guard let people = people else {
            return self
        }

        let value = people
            .map(String.init)
            .joined(separator: ",")

        return appendingQueryItem(name: QueryItemName.withPeople, value: value)
    }

}
