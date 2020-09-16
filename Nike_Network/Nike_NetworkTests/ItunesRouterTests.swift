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
    
    func test_defaultNikeRouter_hasExpectedValuesDescribedInTheAssignment() {
        // GIVEN
        let sut = ITunesRouter.nikeDefault
        
        let expected = makeSUT(
            countryOrRegion: "us",
            mediaType: "apple-music",
            feedType: "top-albums",
            genre: "all",
            resultsLimit: 100,
            format: "json"
        )
        
        // THEN
        XCTAssertEqual(sut, expected)
    }
    
    func test_init_hasExpectedHTTPRouterProperties() {
        // GIVEN
            
        let countryOrRegion = anyRandomNonEmptyString()
        let mediaType = anyRandomNonEmptyString()
        let feedType = anyRandomNonEmptyString()
        let genre =  anyRandomNonEmptyString()
        let resultsLimit = anyInt()
        let format = anyRandomNonEmptyString()
        let allowExplicit = Bool.random()

        let expectedPath = "/api/v1/\(countryOrRegion)/\(mediaType)/\(feedType)/\(genre)/\(resultsLimit)/\(allowExplicit ? "explicit" : "non-explicit").\(format)"

        // WHEN
        let sut = makeSUT(
            countryOrRegion: countryOrRegion,
            mediaType: mediaType,
            feedType: feedType,
            genre: genre,
            resultsLimit: resultsLimit,
            format: format,
            allowExplicit: allowExplicit
        )
        
        // THEN
        let expected = [
            (sut.method, "GET"),
            (sut.host, "rss.itunes.apple.com"),
            (sut.scheme, "https"),
            (sut.path, expectedPath)
        ].allSatisfy { $0 == $1 }
        
        XCTAssert(expected)
        XCTAssert(sut.parameters.isEmpty)
        XCTAssert(sut.additionalHttpHeaders.isEmpty)
    }
    
    func test_itunesRouterInstance_isURLRequestConvertible() {
        XCTAssert(ITunesRouter.nikeDefault is URLRequestConvertible)
    }
        
    // MARK: - Helpers
    
    private func makeSUT(
        countryOrRegion: String = anyRandomNonEmptyString(),
        mediaType: String = anyRandomNonEmptyString(),
        feedType: String = anyRandomNonEmptyString(),
        genre: String = anyRandomNonEmptyString(),
        resultsLimit: Int = anyInt(),
        format: String = anyRandomNonEmptyString(),
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

