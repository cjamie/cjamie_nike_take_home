//
//  File.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

public struct ITunesRouter: URLRequestableHTTPRouter, Equatable {
    
    public static let nikeDefault = ITunesRouter(
        countryOrRegion: Constants.unitedStates,
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
    
    init(countryOrRegion: String, mediaType: String, feedType: String, genre: String, resultsLimit: Int, format: String, allowExplicit: Bool) {
        self.countryOrRegion = countryOrRegion
        self.mediaType = mediaType
        self.feedType = feedType
        self.genre = genre
        self.resultsLimit = resultsLimit
        self.format = format
        self.allowExplicit = allowExplicit
    }
    
    
    // MARK: - HTTPRouter
    
    public var method: String {
        return Constants.get
    }
    
    public var host: String {
        return Constants.itunesHost
    }
    
    public var scheme: String {
        return Constants.https
    }
    
    public var path: String {
        
        let explicitString = allowExplicit ? "explicit" : "non-explicit"
        
        return "/api/v1/\(countryOrRegion)/\(mediaType)/\(feedType)/\(genre)/\(resultsLimit)/\(explicitString).\(format)"
        
    }
    
    public var parameters: [String : String] {
        return [:]
    }
    
    public var additionalHttpHeaders: [String : String] {
        return [:]
    }

    // MARK: - Helpers
    
    private enum Constants {
        static let get = "GET"
        static let https = "https"
        static let itunesHost = "rss.itunes.apple.com"
        static let unitedStates = "us"
        static let appleMusic = "apple-music"
        static let topAlbums = "top-albums"
        static let genreAll = "all"
        static let resultsLimit = 100
        static let json = "json"
    }
        
}
