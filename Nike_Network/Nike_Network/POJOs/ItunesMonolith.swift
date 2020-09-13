//
//  ItunesMonolith.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation


public struct ItunesMonolith: Codable, Equatable {
    let feed: Feed
}

// MARK: - Feed
public struct Feed: Codable, Equatable {
    let title: String
    let id: String // this probably should not be url
    let author: Author
    let links: [Link]
    let copyright, country: String
    let icon: URL
    let updated: Date
    let results: [AlbumResult]
}

// MARK: - Author
struct Author: Codable, Equatable {
    let name: String
    let uri: URL // this can be url
}

// MARK: - Link
struct Link: Codable, Equatable {
    let linkSelf: URL? // this can be url
    let alternate: URL? // this can be url

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
        case alternate
    }
}

// MARK: - Result
struct AlbumResult: Codable, Equatable {
    let artistName, id, releaseDate, name: String
    let kind: Kind
    let copyright: String?
    let artistID: String
    let contentAdvisoryRating: String? // TODO: - this should be an enum?
    let artistURL: URL
    let artworkUrl100: URL
    let genres: [Genre]
    let url: URL

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name, kind, copyright
        case artistID = "artistId"
        case contentAdvisoryRating
        case artistURL = "artistUrl"
        case artworkUrl100, genres, url
    }
}

// MARK: - Genre
struct Genre: Codable, Equatable {
    let genreID: String
    let name: String
    let url: URL

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Kind: String, Codable, Equatable {
    case album = "album"
}
