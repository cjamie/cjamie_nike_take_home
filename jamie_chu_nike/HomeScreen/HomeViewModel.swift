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
    private var _rawModels: [ItunesMonolith] = []
    private let imageDataCache = NSCache<NSString, NSData>()
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
                self._rawModels.append(rawModel)

                self.albumCellModels.value = rawModel.feed.results.map {
                    AlbumCellViewModelImpl(
                        nameOfAlbum: "Album: \($0.name)",
                        artist: "Artist: \($0.artistName)",
                        thumbnailImageURL: $0.artworkUrl100,
                        dataFetcher: RemoteDataFetcherWithCacheFallback(
                            session: .shared,
                            url: $0.artworkUrl100,
                            imageDataCache: self.imageDataCache
                        )
                    )
                }
            }
        }
    }
    
    func albumInfoViewModel(at row: Int) -> AlbumInfoViewModel? {
        guard let rawModels = _rawModels.last else { return nil }
        // TODO: - test that this will not crash
        guard let album = rawModels.feed.results[safeIndex: row] else { return nil }
        
        let genreNames: String = album.genres.map { $0.name }.joined(separator: ", ")

        return AlbumInfoViewModelImpl(
            nameOfAlbum: .init("AameOfAlbum: \(album.name)"),
            artist: .init("Artist: \(album.artistName)"),
            thumbnailImage: album.artworkUrl100,
            genre: .init("Genre: \(genreNames)"),
            releaseDate: .init("ReleaseDate: \(album.releaseDate)"),
            copyrightDescription: .init("CopyrightDescription: \(album.copyright ?? "")"),
            albumURL: album.url,
            dataFetcher: RemoteDataFetcherWithCacheFallback(url: album.artworkUrl100, imageDataCache: imageDataCache)
        )
    }
}
