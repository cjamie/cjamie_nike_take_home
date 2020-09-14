
//
//  AlbumCellViewModel.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

//    Each cell should display the name of the album, the artist, and the album art (thumbnail image).
// TODO: - add fetcher service
protocol AlbumCellViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<URL> { get }
    var imageDataCache: NSCache<NSString, NSData> { get }
}

struct AlbumCellViewModelImpl: AlbumCellViewModel {
    
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<URL>
    let imageDataCache: NSCache<NSString, NSData>

    init(nameOfAlbum: String, artist: String, thumbnailImage: URL, imageDataCache: NSCache<NSString, NSData>) {
        self.nameOfAlbum = Box(nameOfAlbum)
        self.artist = Box(artist)
        self.thumbnailImage = Box(thumbnailImage)
        self.imageDataCache = imageDataCache
    }
}


//protocol AlbumInfoViewModel {
//    var nameOfAlbum: Box<String> { get }
//    var artist: Box<String> { get }
//    var thumbnailImage: Box<URL> { get }
//    var genre: Box<String> { get }
//    var releaseDate: Box<Date> { get }
//    var copyrightDescription: Box<String> { get }
//}
//NSCache<NSString, NSData>()
