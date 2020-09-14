//
//  ItunesMonolith.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

// TODO: separate file for each model

public struct ItunesMonolith: Codable, Equatable {
    public let feed: Feed
}

// MARK: - Feed
public struct Feed: Codable, Equatable {
    public let title: String
    public let id: String // this probably should not be url
    public let author: Author
    public let links: [Link]
    public let copyright, country: String
    public let icon: URL
    public let updated: Date
    public let results: [AlbumResult]
}

// MARK: - Author
public struct Author: Codable, Equatable {
    public let name: String
    public let uri: URL // this can be url
}

// MARK: - Link
public struct Link: Codable, Equatable {
    public let linkSelf: URL? // this can be url
    public let alternate: URL? // this can be url

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
        case alternate
    }
}

// MARK: - Result
public struct AlbumResult: Codable, Equatable {
    public let artistName, id, releaseDate, name: String
    public let kind: Kind
    public let copyright: String?
    public let artistID: String
    public let contentAdvisoryRating: String? // TODO: - this should be an enum?
    public let artistURL: URL
    public let artworkUrl100: URL
    public let genres: [Genre]
    public let url: URL

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name, kind, copyright
        case artistID = "artistId"
        case contentAdvisoryRating
        case artistURL = "artistUrl"
        case artworkUrl100, genres, url
    }
}

// MARK: - Genre
public struct Genre: Codable, Equatable {
    public let genreID: String
    public let name: String
    public let url: URL

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

public enum Kind: String, Codable {
    case album = "album"
}
