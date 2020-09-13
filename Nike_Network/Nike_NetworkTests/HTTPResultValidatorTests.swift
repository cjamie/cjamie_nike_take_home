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
        let sut: DecodableResultProcessor<SomeDecodable> = makeSUT(
            data: anyData(),
            response: anyURLResponse()
        )
        
        let result = sut.process()
        
        switch result {
        case .failure(let error):
            XCTFail("unintended with this test")
        case .success(let decodable):
            XCTAssertTrue(true)
        }
    }
    
    // MARK: - Helpers

    func makeSUT<T: Decodable>(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil
    ) -> DecodableResultProcessor<T> {
        return DecodableResultProcessor(rawResponse: (data, response, error), decoder: .init())
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://google.com/")!
    }
    
    private func anyData() -> Data {
        return Data()
    }
    
    func anyURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    }
    
}


//struct DecodableResultProcessor<T: Decodable> {
//    typealias RawResponse = (data: Data?, response: URLResponse?, error: Error?)
//    private let decoder: JSONDecoder
//    private let rawResponse: RawResponse
//
//    // MARK: - Init
//
//    init(rawResponse: RawResponse, decoder: JSONDecoder) {
//        self.rawResponse = rawResponse
//        self.decoder = decoder
//    }
//
//    // MARK: - Public API
//
//    func process() -> Result<T, Error> {
//        if let error = rawResponse.error {
//            return .failure(NetworkingError.swift(error))
//        }
//
//        return .failure(NSError())
//    }
//}

private struct SomeDecodable: Decodable, Equatable {
    
}
