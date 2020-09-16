//
//  AlbumInfoViewModel.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation
import Nike_Network

protocol AlbumInfoViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<(Data, URL)> { get }
    var genre: Box<String> { get }
    var releaseDate: Box<String> { get }
    var copyrightDescription: Box<String> { get }
    var albumURL: URL { get }
    
    func start()
}

final class AlbumInfoViewModelImpl: AlbumInfoViewModel {
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<(Data, URL)>
    let genre: Box<String>
    let releaseDate: Box<String>
    let copyrightDescription: Box<String>
    let albumURL: URL
    private let dataFetcher: DataURLFetcher
    
    init(nameOfAlbum: String, artist: String, thumbnailImage: URL, genre: String, releaseDate: String, copyrightDescription: String, albumURL: URL, dataFetcher: DataURLFetcher) {
        self.nameOfAlbum = Box(nameOfAlbum)
        self.artist = Box(artist)
        self.thumbnailImage = Box((Data(), thumbnailImage))
        self.genre = Box(genre)
        self.releaseDate = Box(releaseDate)
        self.copyrightDescription = Box(copyrightDescription)
        self.albumURL = albumURL
        self.dataFetcher = dataFetcher
    }
    
    func start() {
        dataFetcher.fetch { [weak self] result in
            switch result {
            case .failure:
                // we will do nothing with an error
                break
            case .success(let (data, url)):
                self?.thumbnailImage.value = (data, url)
            }
        }
    }
}
