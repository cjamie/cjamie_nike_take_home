//
//  AlbumCellViewModelTests.swift
//  second_jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import jamie_chu_nike
import Nike_Network

class AlbumCellViewModelTests: XCTestCase {

    func test_init_boxValues() {
        // GIVEN
        let expectedNameOfAlbum = anyRandomNonEmptyString()
        let expectedArtist = anyRandomNonEmptyString()
        let expectedThumbnailImageURL = anyURL()
        
        // WHEN
        let sut = makeSUT(
            nameOfAlbum: expectedNameOfAlbum,
            artist: expectedArtist,
            thumbnailImageURL: expectedThumbnailImageURL
        )
        
        //THEN
        XCTAssertEqual(expectedNameOfAlbum, sut.nameOfAlbum.value)
        XCTAssertEqual(expectedArtist, sut.artist.value)

        XCTAssertEqual(expectedThumbnailImageURL, sut.thumbnailImage.value.1)
        XCTAssertEqual(expectedThumbnailImageURL, sut.thumbnailImageURL)

        XCTAssertEqual(Data(), sut.thumbnailImage.value.0)
    }
    
    func test_start_willModifyThumbnailImageBoxValue_ifSuccessBlockIsCalled() {
        // GIVEN
        guard let expectedData = randomCustomData() else {
            XCTFail()
            return
        }
        let sut = makeSUT(data: expectedData)
        // WHEN
        sut.start()
        
        // THEN
        let acutalData = sut.thumbnailImage.value.0
        
        XCTAssertEqual(expectedData, acutalData)
        
    }

    
    func test_start_initialThumbnailImageBoxValue_willNotChange_ifFailureBlockIsCalled() {
        // GIVEN
        guard let inputData = randomCustomData() else {
            XCTFail()
            return
        }
        let sut = makeSUT(options: .failure, data: inputData)
        let initialValue = sut.thumbnailImage.value.0
        
        // WHEN
        sut.start()
        
        // THEN
        
        let valueAfterCallingStart = sut.thumbnailImage.value.0
        XCTAssertEqual(initialValue, valueAfterCallingStart)
        XCTAssertNotEqual(inputData, valueAfterCallingStart)
    }
    
    private enum SucceedFailure {
        case succeed
        case failure
        
        func fetcher(url: URL, data: Data) -> DataURLFetcher {
            switch self {
            case .succeed:
                return MockSuccessFetcher(url: url, returnedData: data)
            case .failure:
                return MockFailureFetcher(url: url, returnedData: data)
            }
        }
    }
        
    private func makeSUT(
        nameOfAlbum: String = anyRandomNonEmptyString(),
        artist: String = anyRandomNonEmptyString(),
        thumbnailImageURL: URL = anyURL(),
        options: SucceedFailure = .succeed,
        data: Data = Data()
    ) -> AlbumCellViewModel {
        AlbumCellViewModelImpl(
            nameOfAlbum: nameOfAlbum,
            artist: artist,
            thumbnailImageURL: thumbnailImageURL,
            dataFetcher: options.fetcher(
                url: thumbnailImageURL,
                data: data
            )
        )
    }

    private struct MockSuccessFetcher: DataURLFetcher {
        
        private let url: URL
        private let data: Data
        
        init(url: URL, returnedData: Data) {
            self.url = url
            self.data = returnedData
        }
        
        func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
            completion(.success((data, url)))
        }
        
    }
    
    private struct MockFailureFetcher: DataURLFetcher {
        
        private let url: URL
        private let data: Data
        
        init(url: URL, returnedData: Data) {
            self.url = url
            self.data = returnedData
        }
        
        func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
            completion(.failure(anySwiftError()))
        }
        
    }
    
    private func randomCustomData() -> Data? {
        return anyRandomNonEmptyString().data(using: .utf8)
    }
}
