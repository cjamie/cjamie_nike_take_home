//
//  AlbumInfoViewModelImplTests.swift
//  second_jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/16/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import jamie_chu_nike
import Nike_Network

class AlbumInfoViewModelImplTests: XCTestCase {

    
    
    func test_start_successfulFetch_doesChangeThumbnailImageValue() {
        let sut = makeSUT(successFail: .success)
        sut.thumbnailImage.bind { _ in }

        let (initialData, initialURL) = sut.thumbnailImage.value
        
        sut.start()
        let (changedData, changedURL) = sut.thumbnailImage.value
        
        XCTAssertNotEqual(initialData, changedData)
        XCTAssertNotEqual(initialURL, changedURL)

    }
    
    func test_start_failedFetch_doesNotChangeThumbnailImageValue() {
        let sut = makeSUT(successFail: .fail)
        sut.thumbnailImage.bind { _ in }

        let (initialData, initialURL) = sut.thumbnailImage.value
        
        sut.start()
        let (changedData, changedURL) = sut.thumbnailImage.value
        
        XCTAssertEqual(initialData, changedData)
        XCTAssertEqual(initialURL, changedURL)
    }

    private enum SuccessFail {
        case success
        case fail
        
        var fetcher: DataURLFetcher {
            switch self {
            case .fail:
                return FailFetcher()
            case .success:
                return SuccessFetcher()
            }
        }
                
        private struct SuccessFetcher: DataURLFetcher {
            func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
                guard let data = anyRandomNonEmptyString().data(using: .utf8) else { fatalError() }
                completion(.success((data, anyURL())))
            }
            
        }
        
        private struct FailFetcher: DataURLFetcher {
            func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
                completion(.failure(anySwiftError()))
            }
        }

    }
    
    private func makeSUT(successFail: SuccessFail = .success) -> AlbumInfoViewModelImpl {
                
        let instance = AlbumInfoViewModelImpl(
            nameOfAlbum: anyRandomNonEmptyString(),
            artist: anyRandomNonEmptyString(),
            thumbnailImage: anyURL(),
            genre: anyRandomNonEmptyString(),
            releaseDate: anyRandomNonEmptyString(),
            copyrightDescription: anyRandomNonEmptyString(),
            albumURL: anyURL(),
            dataFetcher: successFail.fetcher)
        return instance
    }
}
