//
//  HTTPRouter.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

public protocol HTTPRouter {
    var method: String { get } // this should not be an enum
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var additionalHttpHeaders: [String: String] { get }
}

extension HTTPRouter {
    
    // MARK: - Public API
    
    func baseURL() throws -> URL {
        let condition = stringComponents.allSatisfy { !$0.isEmpty }
        guard condition else { throw NetworkingError.malformedURL }
        
        var components = URLComponents()
        components.host = host
        components.scheme = scheme
        components.path = path
        components.queryItems = parameters.map { .init(name: $0.key, value: $0.value) }
        
        guard let returnURL = components.url else { throw NetworkingError.malformedURL }
        return returnURL
    }
    
    // MARK: Helpers
    
    private var stringComponents: [String] {
        [host, scheme, path]
    }
}

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension HTTPRouter where Self: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        guard !method.isEmpty else { throw NetworkingError.malformedRequest }
        var request = URLRequest(url: try baseURL())
        request.httpMethod = method
        request.allHTTPHeaderFields = additionalHttpHeaders
        return request
    }
}
