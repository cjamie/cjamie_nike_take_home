//
//  DataResultProcessorTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class DataResultProcessorTests: XCTestCase {

    func test_withError_returnsNativeError_inResult() {
        // GIVEN
        let error = anySwiftError()
        let (_, result) = makeSUT(error: error)
        let expected = NetworkingError.swift(error)
            
        // THEN
        switch result {
        case .failure(let actual):
            XCTAssertEqual(expected, actual as? NetworkingError)
        case .success:
            XCTFail()
        }
    }

    func test_validresponseAndData_returnsDataInSuccess() {
        // GIVEN
        let validResponse = HTTPURLResponse(
            url: anyURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let expectedData = anyData()
        
        // WHEN
        let (_, result) = makeSUT(data: expectedData, response: validResponse)
        
        // THEN
        switch result {
        case .success(let actualData):
            XCTAssertEqual(actualData, expectedData)
        case .failure:
            XCTFail()
        }
    }
    
    func test_validResponse_withBadResponseCode_withValidEmptyStringData_returnsNoResponseError() {
        // GIVEN
        let invalidStatusCode = 404
        let validResponse = HTTPURLResponse(
            url: anyURL(),
            statusCode: invalidStatusCode,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectedError = NetworkingError.badResponse(code: invalidStatusCode)
        // WHEN
        
        let (_, result) = makeSUT(data: anyData(), response: validResponse)
        
        // THEN
        switch result {
        case .success:
            XCTFail()
        case .failure(let actualError):
            XCTAssertEqual(actualError as? NetworkingError, expectedError)
        }
    }
    
    
    
    func test_withResponse_thatCannotBeDowncasted_toHTTPURLResponse_returnsNoReponseError() {
        let (_, result) = makeSUT(response: anyURLResponse())
        
        let expectedError = NetworkingError.noResponse
        switch result {
            case .success:
                XCTFail()
            case .failure(let actualError):
                XCTAssertEqual(actualError as? NetworkingError, expectedError)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) -> (sut: DataResultProcessor, result: Result<Data, Error>) {
        let processor = DataResultProcessor(rawResponse: (data, response, error))
        return (processor, processor.result)
    }
    
    struct DataResultProcessor {
        let rawResponse: RawResponse
        
        var result: Result <Data, Error> {
            if let error = rawResponse.error {
                return .failure(NetworkingError.swift(error))
            }
            guard let responseCode = (rawResponse.response as? HTTPURLResponse)?.statusCode else {
                return .failure(NetworkingError.noResponse)
            }
            guard Self.acceptableResponseCodes.contains(responseCode) else {
                if let data = rawResponse.data, let serverErrorString = String(data: data, encoding: .utf8), !serverErrorString.isEmpty {
                    return .failure(NetworkingError.serverError(serverErrorString))
                }
                return .failure(NetworkingError.badResponse(code: responseCode))
            }
            guard let data = rawResponse.data else {
                return .failure(NetworkingError.noData)
            }
            return .success(data)
        }

        // MARK: - Helpers
        private static let acceptableResponseCodes = (200...304) // we should be able to accept many response codes

    }
    
}
