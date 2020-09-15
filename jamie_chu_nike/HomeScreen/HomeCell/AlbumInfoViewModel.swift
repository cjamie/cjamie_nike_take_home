//
//  AlbumInfoViewModel.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

protocol AlbumInfoViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<URL> { get }
    var genre: Box<String> { get }
    var releaseDate: Box<String> { get }
    var copyrightDescription: Box<String> { get }
    var imageDataCache: NSCache<NSString, NSData> { get }
    var albumURL: URL { get }
}

struct AlbumInfoViewModelImpl: AlbumInfoViewModel {
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<URL>
    let genre: Box<String>
    let releaseDate: Box<String>
    let copyrightDescription: Box<String>
    let imageDataCache: NSCache<NSString, NSData>
    let albumURL: URL
}
