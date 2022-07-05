import Foundation

final actor TMDbConfigurationService: ConfigurationService {

    private let apiClient: APIClient
    private var configurationTask: Task<APIConfiguration, Error>?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func apiConfiguration() async throws -> APIConfiguration {
        if let configurationTask = configurationTask, let value = try? await configurationTask.value {
            return value
        }

        let task = Task<APIConfiguration, Error> {
            return try await apiClient.get(endpoint: ConfigurationEndpoint.api)
        }

        self.configurationTask = task
        return try await task.value
    }

    func countries() async throws -> [Country] {
        try await apiClient.get(endpoint: ConfigurationEndpoint.countries)
    }

}
