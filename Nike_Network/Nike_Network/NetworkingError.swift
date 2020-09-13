//
//  NetworkingError.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

enum NetworkingError: Error, Equatable {
    
    case malformedURL
    case malformedRequest
    case swift(Error)
    case noResponse
    case badResponse(code: Int)
    case noData
    case noImage
    case jsonDecoding(Error)
    case serverError(String)
    
    // MARK: - Equatable
    
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        switch (lhs, rhs) {
        case (.malformedURL, .malformedURL),
             (.malformedRequest, .malformedRequest),
             (.noResponse, .noResponse),
             (.noData, .noData),
             (.noImage, .noImage):
            return true
        case let (.swift(error1), .swift(error2)):
            return error1.localizedDescription == error2.localizedDescription
        // TOOD: - need to capture these errors somehow in tests
        case let (.jsonDecoding(error1), .jsonDecoding(error2)):
            return true
        case let (.badResponse(code1), .badResponse(code2)):
            return code1 == code2
        case let (.serverError(string1), .serverError(string2)):
            return string1 == string2
        default:
            return false
        }
    }
}
