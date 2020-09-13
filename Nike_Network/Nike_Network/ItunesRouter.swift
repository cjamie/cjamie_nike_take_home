//
//  File.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

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
