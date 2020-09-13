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
    
    func test_defaultRouter_hasExpectedValuesDescribedInTheAssignment() {
        
        let sut = ITunesRouter.nikeDefault
        
        let expected = makeSUT(
            countryOrRegion: "United States",
            mediaType: "apple-music",
            feedType: "top-albums",
            genre: "all",
            resultsLimit: 100,
            format: "json"
        )
        
        XCTAssertEqual(sut, expected)
    }
    
    //sample iPhone app that displays the top 100 albums across all genres using Apple’s RSS generator
    
    private func makeSUT(
        countryOrRegion: String = anyString(),
        mediaType: String = anyString(),
        feedType: String = anyString(),
        genre: String = anyString(),
        resultsLimit: Int = anyInt(),
        format: String = anyString(),
        allowExplicit: Bool = true
    ) -> ITunesRouter {
        // all inputted values can be in dictionaries
        return ITunesRouter(
            countryOrRegionKey: countryOrRegion,
            mediaType: mediaType,
            feedType: feedType,
            genre: genre,
            resultsLimit: resultsLimit,
            format: format,
            allowExplicit: allowExplicit
        )
    }

    // reason we are not using enum is because its bad choice
    struct ITunesRouter: HTTPRouter, Equatable {
        
        static let nikeDefault = ITunesRouter(
            countryOrRegionKey: Constants.unitedStates,
            mediaType: Constants.appleMusic,
            feedType: Constants.topAlbums,
            genre: Constants.genreAll,
            resultsLimit: Constants.resultsLimit,
            format: Constants.json,
            allowExplicit: true
        )
        
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
            static let unitedStates = "United States"
            static let appleMusic = "apple-music"
            static let topAlbums = "top-albums"
            static let genreAll = "all"
            static let resultsLimit = 100
            static let json = "json"
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

