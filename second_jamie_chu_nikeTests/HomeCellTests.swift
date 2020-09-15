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
        let (sut, viewModel) = makeSUT()
        
        sut.bind(model: viewModel)
    
        
        
    }
    
    // MARK: - Helpers
    
    private struct AlbumCellViewModelSpy: AlbumCellViewModel {
//        var thumbnailImage: Box<Data>
//        
//        var dataFetcher: DataFetcher
//        
//        func invokeFetch() {
//            <#code#>
//        }
        
        let nameOfAlbum: Box<String> = Box("")
        let artist: Box<String> = Box("")
        let thumbnailImage: Box<Data> = Box(anyURL())
        let imageDataCache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()
    }
    
    private func makeSUT() -> (HomeCell, AlbumCellViewModel) {
        let cellViewModel = AlbumCellViewModelSpy()
        return (HomeCell(style: .default, reuseIdentifier: HomeCell.reuseIdentifier), cellViewModel)
    }

    
}
