//
//  DecodableResultProcessor.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

typealias RawResponse = (data: Data?, response: URLResponse?, error: Error?)

struct DecodableResultProcessor<T: Decodable> {
    private let decoder: JSONDecoder
    private let rawResponse: RawResponse
    
    // MARK: - Init
    
    init(rawResponse: RawResponse, decoder: JSONDecoder) {
        self.rawResponse = rawResponse
        self.decoder = decoder
    }
    
    // MARK: - Public API
    
    func process() -> Result<T, Error> {
        if let error = rawResponse.error {
            return .failure(NetworkingError.swift(error))
        }
        guard let responseCode = (rawResponse.response as? HTTPURLResponse)?.statusCode else {
            return .failure(NetworkingError.noResponse)
        }
        return .failure(NSError())
//        guard Self.acceptableResponseCodes.contains(responseCode) else {
//            if let data = rawResponse.data, let serverErrorString = String(data: data, encoding: .utf8) {
//                return .failure(NetworkingError.serverError(serverErrorString))
//            }
//            return .failure(NetworkingError.badResponse(code: responseCode))
//        }
//        guard let data = rawResponse.data else {
//            return .failure(NetworkingError.noData)
//        }
//        return .success(data)
    }
    
//    private static let acceptableResponseCodes = (200...304)
    
}
