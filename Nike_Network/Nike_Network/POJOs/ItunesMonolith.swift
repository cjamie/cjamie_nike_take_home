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
    let id: String
    let author: Author
    let links: [Link]
    let copyright, country: String
    let icon: String
    let updated: String
    let results: [AlbumResult]
}

// MARK: - Author
struct Author: Codable, Equatable {
    let name: String
    let uri: String
}

// MARK: - Link
struct Link: Codable, Equatable {
    let linkSelf: String?
    let alternate: String?

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
    let artistURL: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String // TODO: - this should be decodable

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
    let name: Name
    let url: String // TODO: - this should be decodable

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Name: String, Codable {
    case country = "Country"
    case hipHopRap = "Hip-Hop/Rap"
    case music = "Music"
}

enum Kind: String, Codable, Equatable {
    case album = "album"
}
