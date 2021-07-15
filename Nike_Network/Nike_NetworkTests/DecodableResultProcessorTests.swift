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
        let originalError = anySwiftError()
        let sut: DecodableResultProcessor<AnyDecodable> = makeSUT()

        // WHEN
        let sutResult = sut.process(rawResponse: (nil, nil, originalError))
        
        // THEN
        switch sutResult {
        case .failure(let error):
            XCTAssertEqual(error as? NetworkingError, .swift(originalError))
        case .success:
            XCTFail()
        }
    }
    
    func test_validResponse_andParsableData_returnsSuccess() {
        // GIVEN
        let sut = DecodableResultProcessor<AnyDecodable>(decoder: .init())
        let expectedDecodedObject = AnyDecodable(title: "Some arbitrary title", id: 1)
        
        // WHEN
        let sutResult = sut.process(rawResponse: (someDecodableStub.data(using: .utf8), validHTTPURLResponse(), nil))


        
        // THEN
        switch sutResult {
        case .success(let actualDecodable):
            XCTAssertEqual(actualDecodable, expectedDecodedObject)
        case .failure:
            XCTFail()
        }
    }
    
    // TODO: - loosened equatable requirement for Networking.jsonDecoding, will want to revisit it in future
    func test_validResponse_andNonParsableData_returnsDecodingFailure() {
        // GIVEN
        let sut = DecodableResultProcessor<AnyDecodable>(decoder: .init())

        let expectedError = NetworkingError.jsonDecoding(anySwiftError())
        
        // WHEN
        let result = sut.process(rawResponse: (
            someNonDecodableStub.data(using: .utf8),
            validHTTPURLResponse(),
            nil
        ))
        
        // THEN
        switch result {
        case .success:
            XCTFail()
        case .failure(let actualError):
            XCTAssertEqual(actualError as? NetworkingError, expectedError)
        }
        
    }
    
    // MARK: - Helpers

    private func makeSUT<T: Decodable>() -> DecodableResultProcessor<T> {
        DecodableResultProcessor<T>(decoder: .init())
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


