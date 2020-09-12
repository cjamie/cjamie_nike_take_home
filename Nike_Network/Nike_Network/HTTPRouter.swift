//
//  HTTPRouter.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

protocol HTTPRouter: URLRequestConvertible {
    var method: String { get } // this should not be an enum
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var additionalHttpHeaders: [String: Any] { get }
}

extension HTTPRouter {
    var baseURL: URL? {
        return {
            var components = URLComponents()
            components.host = host
            components.scheme = scheme
            components.path = path
            components.queryItems = parameters.map { .init(name: $0.key, value: "\($0.value)") }
    
            return components.url
        }()
    }
}

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}


enum NetworkingErrors: Error, LocalizedError {
    case malformedURL
    case malformedRequest
    case swift(Error)
    case noResponse
    case badResponse(code: Int)
    case noData
    case noImage
    case jsonDecoding(Error)
    case serverError(String)
    // MARK: - LocalizedError
    
    var errorDescription: String? {
        let description: String
        
        switch self {
        case .malformedURL:
            description = "Failed to create a URL"
        case .malformedRequest:
            description = "Failed to create a request"
        case .noData:
            description = "There is no data returned"
        case .swift(let error):
            description = error.localizedDescription
        case .noResponse:
            description = "No response"
        case .badResponse(code: let code):
            description = "Bad response code: \(code)"
        case .noImage:
            description = "No image"
        case .jsonDecoding(let error):
            description = "Json decoding error: \(error.localizedDescription)"
        case .serverError(let errorString):
            description = errorString
            return errorString
        }
        
        return "\(Self.self)" + ": " + description
    }
}
