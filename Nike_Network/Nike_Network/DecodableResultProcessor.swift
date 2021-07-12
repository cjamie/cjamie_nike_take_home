//
//  DecodableResultProcessor.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

typealias RawResponse = (data: Data?, response: URLResponse?, error: Error?)

public struct DecodableResultProcessor<T: Decodable> {

    private let decoder: JSONDecoder

    // MARK: - Init
    
    public init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    // MARK: - Public API
    
    func process(rawResponse: RawResponse) -> Result<T, Error> {
        switch ResponseToDataReducer(rawResponse: rawResponse).result {
        case .failure(let processedError):
            return .failure(processedError)

        case .success(let data):
            
            do {
                let successfullyDecodedInstance = try decoder.decode(T.self, from: data)
                return .success(successfullyDecodedInstance)
            } catch {
                return .failure(NetworkingError.jsonDecoding(error))
            }
        }
    }
}
