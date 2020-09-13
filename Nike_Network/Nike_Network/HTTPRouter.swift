//
//  HTTPRouter.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

protocol HTTPRouter {
    var method: String { get } // this should not be an enum
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var additionalHttpHeaders: [String: String] { get }
}

extension HTTPRouter {
    
    // MARK: - Public API
    
    func baseURL() throws -> URL? {
            let condition = stringComponents.allSatisfy { !$0.isEmpty }
        
            guard condition else { throw NetworkingError.malformedURL }

            var components = URLComponents()
            components.host = host
            components.scheme = scheme
            components.path = path
            components.queryItems = parameters.map { .init(name: $0.key, value: $0.value) }
    
            return components.url
    }
    
    // MARK: Helpers
    
    private var stringComponents: [String] {
        [host, scheme, path]
    }
}

extension HTTPRouter where Self: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        guard let baseURL = try? baseURL() else { throw NetworkingError.malformedURL }
        var request = URLRequest(url: baseURL)
        request.httpMethod = method
        additionalHttpHeaders.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}


protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

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
        case let (.swift(error1), .swift(error2)),
             let (.jsonDecoding(error1), .jsonDecoding(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.badResponse(code1), .badResponse(code2)):
            return code1 == code2
        case let (.serverError(string1), .serverError(string2)):
            return string1 == string2
        default:
            return false
        }
    }
}


enum ItunesRouter: HTTPRouter {
    
    case topAlbumsAcrossAllGenres(count: Int)
    
    private enum Constants {
        static let get = "GET"
        static let https = "https"
    }
    
    var method: String {
        switch self {
        case .topAlbumsAcrossAllGenres:
            return Constants.get
        }
    }
    
    var host: String {
        switch self {
        case .topAlbumsAcrossAllGenres:
            return "rss.itunes.apple.com"
        }
    }
    
    var scheme: String {
        switch self {
        case .topAlbumsAcrossAllGenres:
            return Constants.https
        }
    }
    
    var path: String {
        switch self {
        case .topAlbumsAcrossAllGenres(let count):
            return "/api/v1/us/apple-music/coming-soon/all/\(count)/explicit.json"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .topAlbumsAcrossAllGenres:
            return [:]
        }
    }
    
    var additionalHttpHeaders: [String : String] {
        switch self {
        case .topAlbumsAcrossAllGenres(let count):
            return [:]
        }

    }
    
    func asURLRequest() throws -> URLRequest {
        throw NetworkingError.noData
    }
}
