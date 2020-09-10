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

    func appendingAPIKey(_ apiKey: String) -> Self {
        appendingQueryItem(name: "api_key", value: apiKey)
    }

    func appendingPage(_ page: Int?) -> Self {
        guard let page = page else {
            return self
        }

        return appendingQueryItem(name: "page", value: page <= 1000 ? page : 1000)
    }

    func appendingFirstAirDateYear(_ year: Int?) -> Self {
        guard let year = year else {
            return self
        }

        return appendingQueryItem(name: "first_air_date_year", value: year)
    }

    func appendingYear(_ year: Int?) -> Self {
        guard let year = year else {
            return self
        }

        return appendingQueryItem(name: "year", value: year)
    }

    func appendingWithPeople(_ withPeople: [Person.ID]?) -> Self {
        guard let withPeople = withPeople else {
            return self
        }

        let value = withPeople
            .map(String.init)
            .joined(separator: ",")

        return appendingQueryItem(name: "with_people", value: value)
    }

}
