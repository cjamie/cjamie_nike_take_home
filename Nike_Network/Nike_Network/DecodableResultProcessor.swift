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
    private let dataResult: Result<Data, Error>
    
    // MARK: - Init
    
    init(rawResponse: RawResponse, decoder: JSONDecoder) {
        self.dataResult = DataResultProcessor(rawResponse: rawResponse).result
        self.decoder = decoder
    }
    
    // MARK: - Public API
    
    func process() -> Result<T, Error> {
        switch dataResult {
        case .failure(let processedError):
            return .failure(processedError)
        case .success(let data):
            
            do {
                let instance = try decoder.decode(T.self, from: data)
                return .success(instance)
            } catch {
                return .failure(NetworkingError.jsonDecoding(error))
            }
        }
    }
}
