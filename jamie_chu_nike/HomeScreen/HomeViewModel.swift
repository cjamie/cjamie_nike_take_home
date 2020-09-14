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
    func homeViewModel(_ homeModel: HomeViewModel, didSelectRowWith viewModel: AlbumInfoViewModel)
}

final class HomeViewModel: NSObject {
    
    // MARK: - Private API
    
    private let recordsfetcher: ItunesRecordFetcher
    private var _rawModels: ItunesMonolith?
    // MARK: - Init
    
    init(recordsfetcher: ItunesRecordFetcher) {
        self.recordsfetcher = recordsfetcher
    }

    // MARK: - Public API
    
    private(set) var albumCellModels: Box<[AlbumCellViewModel]> = Box([])
    var delegate: HomeViewModelDelegate?

    func start() {
        recordsfetcher.fetchDefaultRaw(router: ITunesRouter.nikeDefault) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.homeViewModel(self, fetchingDidFailWith: error)
            case .success(let rawModel):
                // NOTE: - strings should be localized here
                let cellModels = rawModel.feed.results.map {
                    AlbumCellViewModelImpl(
                        nameOfAlbum: "Album: \($0.name)",
                        artist: "Artist: \($0.artistName)",
                        thumbnailImage: $0.artistURL
                    )
                }
                
                self.albumCellModels.value = cellModels
                self._rawModels = rawModel
            }
        }
    }
    
    func albumInfoViewModel(at row: Int) -> AlbumInfoViewModel? {
        guard let rawModels = _rawModels else { return nil }
        
        let album = rawModels.feed.results[row]
        let genreNames: [String] = album.genres.map { $0.name }

        return AlbumInfoViewModelImpl(
            nameOfAlbum: .init(album.name),
            artist: .init(album.artistName),
            thumbnailImage: .init(album.artworkUrl100),
            genre: .init(genreNames),
            releaseDate: .init(album.releaseDate),
            copyrightDescription: .init(album.releaseDate)
        )
    }
}
