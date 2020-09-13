//
//  DecodableResultProcessorTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class DecodableResultProcessorTests: XCTestCase {
    
    func test_init_withOnlyError_returnsWrappedNativeSwiftError_whenProcessed() {        
        // GIVEN
        let error = anySwiftError()
        let sut: DecodableResultProcessor<AnyDecodable> = makeSUT(error: error)
        let expectedError = NetworkingError.swift(error)
        
        // WHEN
        let sutResult = sut.process()
        
        // THEN
        switch sutResult {
        case .failure(let error):
            XCTAssertEqual(error as? NetworkingError, expectedError)
        case .success:
            XCTFail()
        }
    }
    
    func test_validResponse_andParsableData_returnsSuccess() {
        // GIVEN
        let sut: DecodableResultProcessor<AnyDecodable> = makeSUT(
            data: someDecodableStub.data(using: .utf8),
            response: validHTTPURLResponse()
        )
        let expectedDecodedObject = AnyDecodable(title: "Some arbitrary title", id: 1)
        
        // WHEN
        let sutResult = sut.process()
        
        // THEN
        switch sutResult {
        case .success(let actualDecodable):
            XCTAssertEqual(expectedDecodedObject, actualDecodable)
        case .failure:
            XCTFail()
        }
    }
    
    // TODO: - loosened equatable requirement for Networking.jsonDecoding, will want to revisit it in future
    func test_validResponse_andNonParsableData_returnsDecodingFailure() {
        // GIVEN
        let sut: DecodableResultProcessor<AnyDecodable> = makeSUT(
            data: someNonDecodableStub.data(using: .utf8),
            response: validHTTPURLResponse()
        )
        
        let expectedError = NetworkingError.jsonDecoding(anySwiftError())
        
        // WHEN
        let result = sut.process()
        
        // THEN
        switch result {
        case .success:
            XCTFail()
        case .failure(let actualError):
            XCTAssertEqual(actualError as? NetworkingError, expectedError)
        }
        
    }
    
    // MARK: - Helpers

    private func makeSUT<T: Decodable>(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil,
        decoder: JSONDecoder = .init()
    ) -> DecodableResultProcessor<T> {
        return DecodableResultProcessor(
            rawResponse: (data, response, error),
            decoder: decoder
        )
    }
    
    private let someDecodableStub = """
    {
        "title": "Some arbitrary title",
        "id": 1
    }
    """
    
    private let someNonDecodableStub = """
        there is just no way this is json parsable ;D
    """

    private struct AnyDecodable: Decodable, Equatable {
        let title: String
        let id: Int
    }
}


