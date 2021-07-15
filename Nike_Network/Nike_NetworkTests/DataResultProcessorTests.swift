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
        let expectedData = anyData()
        
        // WHEN
        let (_, result) = makeSUT(data: expectedData, response: validHTTPURLResponse())
        
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
        
        guard let validResponse = validHTTPURLResponse(code: invalidStatusCode) else {
            XCTFail()
            return
        }
        
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
        // GIVEN, WHEN
        let (_, result) = makeSUT(response: anyURLResponse())
        let expectedError = NetworkingError.noResponse
        // THEN
        switch result {
            case .success:
                XCTFail()
            case .failure(let actualError):
                XCTAssertEqual(actualError as? NetworkingError, expectedError)
        }
    }
    
    func test_validResponse_withNonEmptyData_thatIsParsableDirectlyToAString_returnsServerError() {
        // GIVEN, WHEN
        let exampleErrorMessageFromServer = "Hello, this is the server here to tell you that something went wrong. 404 or something :shrug:"
        let messageAsData = exampleErrorMessageFromServer.data(using: .utf8)
        let expectedError = NetworkingError.serverError(exampleErrorMessageFromServer)
        let badStatusCode = 404
        
        let (_, result) = makeSUT(data: messageAsData, response: validHTTPURLResponse(code: badStatusCode))
        
        // THEN
        switch result {
        case .failure(let actualError):
            XCTAssertEqual(actualError as? NetworkingError, expectedError)
        case .success:
            XCTFail()
        }
    }
    
    func test_validResponse_withoutData_returnsNoDataError() {
        // GIVEN, WHEN
        let (_, result) = makeSUT(response: validHTTPURLResponse())
        let expectedError = NetworkingError.noData
        
        // THEN
        switch result {
        case .success:
            XCTFail()
        case .failure(let actualError):
            XCTAssertEqual(expectedError, actualError as? NetworkingError)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil
    ) -> (sut: ResponseToDataReducer, result: Result<Data, Error>) {
        let processor = ResponseToDataReducer(rawResponse: (data, response, error))
        return (processor, processor.result)
    }
}
