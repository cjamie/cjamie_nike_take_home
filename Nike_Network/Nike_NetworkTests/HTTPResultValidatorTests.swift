//
//  HTTPResultValidatorTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class HTTPResultValidatorTests: XCTestCase {
    
    func test_init_withOnlyError_returnsWrappedNativeSwiftError_whenProcessed() {
        
        // GIVEN
        let error = anySwiftError()
        let sut: DecodableResultProcessor<SomeDecodable> = makeSUT(error: error)
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
    
    func test_init_withResponseAndData_returnsSuccess() {
        // TODO: - 
//        let sut: DecodableResultProcessor<SomeDecodable> = makeSUT(
//            data: anyData(),
//            response: anyURLResponse()
//        )
//
//        let result = sut.process()
//
//        switch result {
//        case .failure(let error):
//            XCTFail("unintended with this test")
//        case .success(let decodable):
//            XCTAssertTrue(true)
//        }
    }
    
    // MARK: - Helpers

    func makeSUT<T: Decodable>(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil
    ) -> DecodableResultProcessor<T> {
        return DecodableResultProcessor(rawResponse: (data, response, error), decoder: .init())
    }
    
    
}

private struct SomeDecodable: Decodable, Equatable {
    
}
