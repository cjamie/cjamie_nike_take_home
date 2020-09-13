//
//  ItunesRouterTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class ItunesRouterTests: XCTestCase {
    
    func test_happyPath
    
    }
    
    //sample iPhone app that displays the top 100 albums across all genres using Apple’s RSS generator
    
    private func makeSecondTunes() -> ITunesRouter {
        // all inputted values can be in dictionaries
        return ITunesRouter(
            countryOrRegionKey: "United States",
            mediaType: "",
            feedType: "",
            genre: "all",
            resultsLimit: 100,
            format: "",
            allowExplicit: true
        )
    }

    // reason we are not using enum is because its bad choice
    struct ITunesRouter: HTTPRouter {
        private let countryOrRegion: String
        private let mediaType: String
        private let feedType: String
        private let genre: String
        private let resultsLimit: Int
        private let format: String
        private let allowExplicit: Bool
        
        init(countryOrRegionKey: String, mediaType: String, feedType: String, genre: String, resultsLimit: Int, format: String, allowExplicit: Bool) {
            self.countryOrRegion = Self.countriesDictionary[countryOrRegionKey] ?? ""
            self.mediaType = mediaType
            self.feedType = feedType
            self.genre = genre
            self.resultsLimit = resultsLimit
            self.format = format
            self.allowExplicit = allowExplicit
        }
        
        
        // MARK: - HTTPRouter
        
        var method: String {
            return Constants.get
        }
        
        var host: String {
            return Constants.itunesHost
        }
        
        var scheme: String {
            return Constants.https
        }
        
        var path: String {
            
            let explicitString = allowExplicit ? "explicit" : "non-explicit"
            
            return "/api/v1/\(countryOrRegion)/\(mediaType)/\(feedType)/\(genre)/\(resultsLimit)/\(explicitString).json"
            
        }
        
        var parameters: [String : String] {
            return [:]
        }
        
        var additionalHttpHeaders: [String : String] {
            return [:]
        }

        // MARK: - Helpers
        
        private enum Constants {
            static let get = "GET"
            static let https = "https"
            static let itunesHost = "rss.itunes.apple.com"
        }
        
        // NOTE: - this is incomplete
        private static let countriesDictionary: [String: String] = [
            "Albania": "al",
            "Algeria": "dz",
            "Angola": "ao",
            "United States": "us",
        ]
        
    }
    
}

