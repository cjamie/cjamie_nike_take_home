
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
    var thumbnailImage: Box<(Data, URL)> { get }
    var thumbnailImageURL: URL { get }

//    var imageDataCache: NSCache<NSString, NSData> { get }
//    var dataFetcher: DataFetcher { get }
    
    func fetchImage()
}


class AlbumCellViewModelImpl: AlbumCellViewModel {
    
    
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<(Data, URL)>
    let thumbnailImageURL: URL
    private let dataFetcher: DataFetcher

    func fetchImage() {
        dataFetcher.fetch { [weak self] result in
            switch result {
            case .failure(let error):
                print("-=- handle the error? \(error.localizedDescription)")
            case let .success(data, url):
                self?.thumbnailImage.value = (data, url)
            }
        }
    }
    
    init(nameOfAlbum: String, artist: String, thumbnailImageURL: URL, dataFetcher: DataFetcher) {
        self.nameOfAlbum = Box(nameOfAlbum)
        self.artist = Box(artist)
        self.thumbnailImage = Box((Data(), thumbnailImageURL))
        self.dataFetcher = dataFetcher
        self.thumbnailImageURL = thumbnailImageURL
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
