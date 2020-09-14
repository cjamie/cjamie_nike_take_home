//
//  HomeViewModel.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation
import Nike_Network

protocol HomeViewModelDelegate: class {
    func homeViewModel(_ homeModel: HomeViewModel, fetchingDidFailWith error: Error)
}

final class HomeViewModel {
    
    // MARK: - Private API
    private let recordsfetcher: ItunesRecordFetcher
    private weak var delegate: HomeViewModelDelegate?
    
    // MARK: - Init
    
    init(recordsfetcher: ItunesRecordFetcher, delegate: HomeViewModelDelegate) {
        self.recordsfetcher = recordsfetcher
        self.delegate = delegate
    }

    // MARK: - Public API
    private(set) var albumCellModels: Box<[AlbumCellViewModel]> = Box([])

    func start() {
        recordsfetcher.fetchDefaultRaw(router: ITunesRouter.nikeDefault) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.homeViewModel(self, fetchingDidFailWith: error)
            case .success(let rawModel):
                let cellModels = rawModel.feed.results.map {
                    AlbumCellViewModelImpl(
                        nameOfAlbum: $0.artistID,
                        artist: $0.artistName,
                        thumbnailImage: $0.artistURL
                    )
                }
                
                self.albumCellModels.value = cellModels
            }
        }
    }
}

//    Each cell should display the name of the album, the artist, and the album art (thumbnail image).
protocol AlbumCellViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<URL> { get }
}

struct AlbumCellViewModelImpl: AlbumCellViewModel {
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<URL>
    
    init(nameOfAlbum: String, artist: String, thumbnailImage: URL) {
        self.nameOfAlbum = Box(nameOfAlbum)
        self.artist = Box(artist)
        self.thumbnailImage = Box(thumbnailImage)
    }
}
