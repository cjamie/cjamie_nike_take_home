//
//  HomeCellTests.swift
//  second_jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//


import XCTest
@testable import jamie_chu_nike
import Foundation

class HomeCellTests: XCTestCase {
    
    func test_homeCell_reuseIdentifier() {
        
        XCTAssertEqual(HomeCell.reuseIdentifier, "\(HomeCell.self)")
    }
    
    func test_homeCell_binding() {
                
        // TODO: - implement tests
        
//        let (sut, viewModel) = makeSUT(
//            nameOfAlbum: ,
//            artist: ,
//            thumbnailImageURL:
//        )
//
//        sut.bind(model: viewModel)
        
    }
    
    // MARK: - Helpers
    
//    private struct AlbumCellViewModelSpy: AlbumCellViewModel {
//
//        let nameOfAlbum: Box<String>
//        let artist: Box<String>
//        let imageDataCache: NSCache<NSString, NSData>
//        let thumbnailImage: Box<(Data, URL)>
//        let thumbnailImageURL: URL
//
//        func start() {
//
//        }
//
//        init(nameOfAlbum: Box<String>, artist: Box<String>, imageDataCache: NSCache<NSString, NSData>, thumbnailImageURL: URL = anyURL()) {
//            self.nameOfAlbum = nameOfAlbum
//            self.artist = artist
//            self.imageDataCache = imageDataCache
//            self.thumbnailImageURL = thumbnailImageURL
//            self.thumbnailImage = Box((.init(), thumbnailImageURL))
//        }
//    }
    
    private func makeSUT() -> (HomeCell, AlbumCellViewModel) {
        let cellViewModel = AlbumCellViewModelImpl(
            nameOfAlbum: anyRandomNonEmptyString(),
            artist: anyRandomNonEmptyString(),
            thumbnailImageURL: anyURL(),
            dataFetcher: MockFetcher()
        )
        
        return (HomeCell(style: .default, reuseIdentifier: HomeCell.reuseIdentifier), cellViewModel)
    }
    
    private func makeSUT(nameOfAlbum: String, artist: String, thumbnailImageURL: URL) -> (HomeCell, AlbumCellViewModel) {
            let cellViewModel = AlbumCellViewModelImpl(
                nameOfAlbum: nameOfAlbum,
                artist: artist,
                thumbnailImageURL: thumbnailImageURL,
                dataFetcher: MockFetcher()
            )
            
            return (HomeCell(style: .default, reuseIdentifier: HomeCell.reuseIdentifier), cellViewModel)
        }

    private struct MockFetcher: DataURLFetcher {

        func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
            completion(.success((.init(), anyURL())))
        }
        
    }
}
