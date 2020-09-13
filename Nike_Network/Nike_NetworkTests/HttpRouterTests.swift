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
        let parameterHeader1 = anyRandomNonEmptyString()
        
        let sut = makeSUT(parameters: [parameterHeader1: anyStringWithoutSpaces()])
        let expected = URL(string: "https://google.com/images?\(parameterHeader1)=\(anyStringWithoutSpaces())")

        // WHEN
        let actual: URL? = try? sut.baseURL()
        
        // THEN
        XCTAssertEqual(actual, expected)
    }
    
    func test_URLRequest_containsMatchingInputAdditionalHttpHeaders() {
        // GIVEN
        let headers = ["Authorization": "someJWTTokenMaybe"]
        let sut = makeSUT(additionalHttpHeaders: headers)
        
        guard let convertibleSut = sut as? URLRequestConvertible else {
            XCTFail("we are testing out the conditional conformance extension")
            return
        }

        // WHEN
        do {
            // THEN
            let actualRequest = try convertibleSut.asURLRequest()
            XCTAssertNotNil(actualRequest.allHTTPHeaderFields)
            XCTAssertEqual(actualRequest.allHTTPHeaderFields, headers)
        } catch {
            XCTFail("Unintended test")
        }
    }
    
    
    func test_baseURL_mustHaveSlashPrefix_inPathProperty() {
        // GIVEN
        let sut = makeSUT(path: "noSlashString")

        // WHEN
        let actualError: Error?
        do {
            _ = try sut.baseURL()
            actualError = nil
        } catch {
            actualError = error
        }
        
        // THEN
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
    
    func test_urlRequest_withEmptyHTTPMethod_throwMalformedRequestError() {
        let sut = makeSUT(method: emptyString())
        let expectedError: NetworkingError = .malformedRequest
        
        let actualError: Error?
        
        if let sut = sut as? URLRequestConvertible {
            do {
                _ = try sut.asURLRequest()
                XCTFail("we try block expected to be invoked")
                actualError = nil
            } catch {
                actualError = error
            }
        } else {
            XCTFail("we are testing out the conditional conformance extension")
            actualError = nil
        }
        
        XCTAssertEqual(expectedError, actualError as? NetworkingError)

    }
    
    func test_urlRequest_willThrowMalformedURLError_ifBaseURLAlsoThrows() {
        let sut = makeSUT(method: emptyString())
        let expectedError: NetworkingError = .malformedRequest
        
        let actualError: Error?
        
        if let sut = sut as? URLRequestConvertible {
            do {
                _ = try sut.asURLRequest()
                XCTFail("we try block expected to be invoked")
                actualError = nil
            } catch {
                actualError = error
            }
        } else {
            XCTFail("we are testing out the conditional conformance extension")
            actualError = nil
        }
        
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
    
    private func makeSUT(
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
    
    private struct HttpRouterSpy: HTTPRouter, URLRequestConvertible {
        let method: String
        let host: String
        let scheme: String
        let path: String
        let parameters: [String : String]
        let additionalHttpHeaders: [String: String]
    }

}
