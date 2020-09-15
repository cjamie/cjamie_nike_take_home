//
//  DataResultProcessor.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

public struct DataResultProcessor {
    private let rawResponse: RawResponse
    
    public init(rawResponse: RawResponse) {
        self.rawResponse = rawResponse
    }
    
    public var result: Result <Data, Error> {
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
