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
            countryOrRegion: "us",
            mediaType: "apple-music",
            feedType: "top-albums",
            genre: "all",
            resultsLimit: 100,
            format: "json"
        )
        
        XCTAssertEqual(sut, expected)
    }
    
    func test_itunesRouter_hasExpectedHTTPRouterProperties() {
        
//        let sut = ITunesRouter.nikeDefault
            
        let countryOrRegion = "us"
        let mediaType = "mediaType"
        let feedType = "feedType"
        let genre = "genre"
        let resultsLimit = anyInt()
        let format = "format"
        let allowExplicit = false
        
        let sut = makeSUT(
            countryOrRegion: countryOrRegion,
            mediaType: mediaType,
            feedType: feedType,
            genre: genre,
            resultsLimit: resultsLimit,
            format: format,
            allowExplicit: false
        )
        
        let expectedPath = "/api/v1/\(countryOrRegion)/\(mediaType)/\(feedType)/\(genre)/\(resultsLimit)/\(allowExplicit ? "explicit" : "non-explicit").\(format)"
        XCTAssertEqual(sut.method, "GET")
        XCTAssertEqual(sut.host, "rss.itunes.apple.com")
        XCTAssertEqual(sut.scheme, "https")
        
        
        XCTAssertEqual(sut.path, "/api/v1/us/\(mediaType)/\(feedType)/\(genre)/\(resultsLimit)/\(allowExplicit ? "explicit" : "non-explicit").\(format)")
        
        XCTAssert(sut.parameters.isEmpty)
        XCTAssert(sut.additionalHttpHeaders.isEmpty)
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
            countryOrRegion: countryOrRegion,
            mediaType: mediaType,
            feedType: feedType,
            genre: genre,
            resultsLimit: resultsLimit,
            format: format,
            allowExplicit: allowExplicit
        )
    }
}

