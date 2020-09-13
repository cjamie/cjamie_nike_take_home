//
//  DecodableResultProcessor.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

struct DecodableResultProcessor<T: Decodable> {
    typealias RawResponse = (data: Data?, response: URLResponse?, error: Error?)
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
        
        return .failure(NSError())
    }
}
