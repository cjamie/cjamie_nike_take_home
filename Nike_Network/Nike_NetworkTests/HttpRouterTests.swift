//
//  MyHttpRouterTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class HttpRouterTests: XCTestCase {
    
    func test_defaultSUT_doesProduceIntendedUrl_withQuestionMarkDelimiter() {
        // GIVEN
        let sut = makeSUT()
        let expected = URL(string: "https://google.com/images?")

        // WHEN
        let actual = try? sut.baseURL()
        // THEN
        XCTAssertEqual(expected, actual)
    }
    
    func test_validSUT_withOneParameter_doesProduceURLWithQueryItems() {
        // GIVEN
        let sut = makeSUT(parameters: [anyString(): anyStringWithoutSpaces()])
        let expected = URL(string: "https://google.com/images?\(anyString())=\(anyStringWithoutSpaces())")

        // WHEN
        let actual: URL? = try? sut.baseURL()
        
        // THEN
        XCTAssertEqual(actual, expected)
    }
    
    func test_URLRequest_containsMatchingInputAdditionalHttpHeaders() {
        // GIVEN
        let headers = ["Authorization": "someJWTTokenMaybe"]
        let sut = makeSUT(additionalHttpHeaders: headers)
        
        let actualRequest: URLRequest?
        // WHEN
        if let sut = sut as? URLRequestConvertible {
            do {
                actualRequest = try sut.asURLRequest()
            } catch {
                actualRequest = nil
            }
        } else {
            actualRequest = nil
            XCTFail("we are testing out the conditional conformance extension")
        }
        
        XCTAssertNotNil(actualRequest?.allHTTPHeaderFields)
        XCTAssertEqual(actualRequest?.allHTTPHeaderFields, headers)
    }
    
    func test_baseURL_mustHaveSlashPrefix_inPathProperty() {
        let sut = makeSUT(path: "noSlashString")
        
        let actualError: Error?
        do {
            _ = try sut.baseURL()
            actualError = nil
        } catch {
            actualError = error
        }
        
        XCTAssertEqual(actualError as? NetworkingError, NetworkingError.malformedURL)
    }
    
    // TODO: - refactor these three tests (host, scheme, path) to single function
    func test_baseURL_withEmptyStringHost_doesThrowMalformedURLError_whenCreatingBaseURL() {
        // GIVEN
        let sut = makeSUT(host: emptyString())
        let expectedError: NetworkingError = .malformedURL

        // WHEN
        let actualError: Error?
        do {
            _ = try sut.baseURL()
            actualError = nil
        } catch {
            actualError = error
        }
        
        // THEN
        XCTAssertEqual(expectedError, actualError as? NetworkingError)
    }
    
    func test_baseURL_withEmptyStringScheme_doesThrowMalformedURLError_whenCreatingBaseURL() {
        // GIVEN
        let sut = makeSUT(host: emptyString())
        let expectedError: NetworkingError = .malformedURL

        // WHEN
        let actualError: Error?
        do {
            _ = try sut.baseURL()
            actualError = nil
        } catch {
            actualError = error
        }

        // THEN
        XCTAssertEqual(expectedError, actualError as? NetworkingError)
    }
    
    func test_baseURL_withEmptyStringPath_doesThrowMalformedURLError_whenCreatingBaseURL() {
        // GIVEN
        let sut = makeSUT(path: emptyString())
        let expectedError: NetworkingError = .malformedURL
        
        // WHEN
        let actualError: Error?
        do {
            _ = try sut.baseURL()
            actualError = nil
        } catch {
            actualError = error
        }

        // THEN
        XCTAssertEqual(expectedError, actualError as? NetworkingError)
    }
    
    func test_routerProperties_containsProperInputs() {
        let sut = makeSUT(
            method: anyString(),
            host: anyHost(),
            scheme: anyScheme(),
            path: anyPath(),
            parameters: emptyDictionary(),
            additionalHttpHeaders: emptyDictionary()
        )
        
        XCTAssertEqual(sut.method, anyString())
        XCTAssertEqual(sut.host, anyHost())
        XCTAssertEqual(sut.scheme, anyScheme())
        XCTAssertEqual(sut.path, anyPath())
        XCTAssertEqual(sut.parameters, emptyDictionary())
        XCTAssertEqual(sut.additionalHttpHeaders, emptyDictionary())
    }
    
    // MARK: - Helpers
    
    func makeSUT(
        method: String = "GET",
        host: String = "google.com",
        scheme: String = "https",
        path: String = "/images",
        parameters: [String : String] = [:],
        additionalHttpHeaders: [String: String] = [:]
    ) -> HTTPRouter {
        return HttpRouterSpy(
            method: method,
            host: host,
            scheme: scheme,
            path: path,
            parameters: parameters,
            additionalHttpHeaders: additionalHttpHeaders
        )
    }
        
    struct HttpRouterSpy: HTTPRouter, URLRequestConvertible {
        let method: String
        let host: String
        let scheme: String
        let path: String
        let parameters: [String : String]
        let additionalHttpHeaders: [String: String]
    }
    
    private func emptyDictionary() -> [String: String] {
        [:]
    }
    
    private func emptyString() -> String {
        ""
    }
    
    private func anyString() -> String{
        "anyString"
    }
    
    private func anyHost() -> String {
        "anyHost"
    }
    
    private func anyScheme() -> String {
        "anyScheme"
    }
    
    private func anyPath() -> String {
        "anyScheme"
    }

    // NOTE: - URLs will add include whitespace encoding if there are spaces
    private func anyStringWithoutSpaces() -> String {
        return "anyStringWithoutSpaces"
    }

}
