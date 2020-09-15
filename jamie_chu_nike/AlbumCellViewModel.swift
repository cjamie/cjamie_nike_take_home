
//
//  AlbumCellViewModel.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

//    Each cell should display the name of the album, the artist, and the album art (thumbnail image).
protocol AlbumCellViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<(Data, URL)> { get }
    var thumbnailImageURL: URL { get }
    func start()
}


final class AlbumCellViewModelImpl: AlbumCellViewModel {
    
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<(Data, URL)>
    let thumbnailImageURL: URL
    
    private let dataFetcher: DataURLFetcher

    func start() {
        dataFetcher.fetch { [weak self] result in
            switch result {
            case .failure:
                // we will do nothing with an error
                break
            case .success(let dataAndURL):
                self?.thumbnailImage.value = dataAndURL
            }
        }
    }
    
    init(nameOfAlbum: String, artist: String, thumbnailImageURL: URL, dataFetcher: DataURLFetcher) {
        self.nameOfAlbum = Box(nameOfAlbum)
        self.artist = Box(artist)
        self.thumbnailImage = Box((.init(), thumbnailImageURL))
        self.dataFetcher = dataFetcher
        self.thumbnailImageURL = thumbnailImageURL
    }
}
