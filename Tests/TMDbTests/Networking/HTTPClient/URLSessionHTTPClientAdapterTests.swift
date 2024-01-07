@testable import TMDb
import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class URLSessionHTTPClientAdapterTests: XCTestCase {

     var httpClient: URLSessionHTTPClientAdapter!
     var baseURL: URL!
     var urlSession: URLSession!

     override func setUpWithError() throws {
         try super.setUpWithError()
         baseURL = try XCTUnwrap(URL(string: "https://some.domain.com/path"))

         let configuration = URLSessionConfiguration.default
         configuration.protocolClasses = [MockURLProtocol.self]
         urlSession = URLSession(configuration: configuration)
         httpClient = URLSessionHTTPClientAdapter(urlSession: urlSession)
     }

     override func tearDown() {
         httpClient = nil
         baseURL = nil
         MockURLProtocol.reset()
         super.tearDown()
     }

     func testGetWhenResponseStatusCodeIs401ReturnsUnauthorisedError() async throws {
         MockURLProtocol.responseStatusCode = 401

         let response: HTTPResponse
         do {
             let url = try XCTUnwrap(URL(string: "/error"))
             response = try await httpClient.get(url: url, headers: [:])
         } catch {
             XCTFail("Unexpected error thrown")
             return
         }

         XCTAssertEqual(response.statusCode, 401)
     }

     func testGetWhenResponseStatusCodeIs404ReturnsNotFoundError() async throws {
         MockURLProtocol.responseStatusCode = 404

         let response: HTTPResponse
         do {
             let url = try XCTUnwrap(URL(string: "/error"))
             response = try await httpClient.get(url: url, headers: [:])
         } catch {
             XCTFail("Unexpected error thrown")
             return
         }

         XCTAssertEqual(response.statusCode, 404)
     }

     func testGetWhenResponseStatusCodeIs404AndHasStatusMessageErrorThrowsNotFoundErrorWithMessage() async throws {
         MockURLProtocol.responseStatusCode = 404
         let expectedData = try Data(fromResource: "error-status-response", withExtension: "json")
         MockURLProtocol.data = expectedData

         let response: HTTPResponse
         do {
             let url = try XCTUnwrap(URL(string: "/error"))
             response = try await httpClient.get(url: url, headers: [:])
         } catch {
             XCTFail("Unexpected error thrown")
             return
         }

         XCTAssertEqual(response.statusCode, 404)
         XCTAssertEqual(response.data, expectedData)
     }

    func testGetWhenResponseHasValidDataReturnsDecodedObject() async throws {
        let expectedStatusCode = 200
        let expectedData = Data("abc".utf8)
        MockURLProtocol.data = expectedData

        let url = try XCTUnwrap(URL(string: "/object"))
        let response = try await httpClient.get(url: url, headers: [:])

        XCTAssertEqual(response.statusCode, expectedStatusCode)
        XCTAssertEqual(response.data, expectedData)
    }

    #if !canImport(FoundationNetworking)
    func testGetURLRequestHasCorrectURL() async throws {
        let path = "/object?key1=value1&key2=value2"
        let expectedURL = try XCTUnwrap(URL(string: path))

        _ = try? await httpClient.get(url: expectedURL, headers: [:])

        let result = MockURLProtocol.lastRequest?.url

        XCTAssertEqual(result, expectedURL)
    }
    #endif

    #if !canImport(FoundationNetworking)
    func testGetWhenHeaderSetShouldBePresentInURLRequest() async throws {
        let header1Name = "Accept"
        let header1Value = "application/json"
        let header2Name = "Content-Type"
        let header2Value = "text/html"

        let url = try XCTUnwrap(URL(string: "/object"))
        let headers = [
            header1Name: header1Value,
            header2Name: header2Value
        ]
        _ = try? await httpClient.get(url: url, headers: headers)

        let lastURLRequest = try XCTUnwrap(MockURLProtocol.lastRequest)
        let result1 = lastURLRequest.value(forHTTPHeaderField: header1Name)
        let result2 = lastURLRequest.value(forHTTPHeaderField: header2Name)

        XCTAssertEqual(result1, header1Value)
        XCTAssertEqual(result2, header2Value)
    }
    #endif

 }
