//
//  RemoteDataFetcherWithCacheFallback.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class RemoteDataFetcherWithCacheFallbackTestCase: XCTestCase {
    
    func test_successfulFetch() {
        let expectedURL = urlThatWillBeSuccessful()
        let (sut, _) = makeSUT(inputURL: expectedURL)
        let myExpect = expectation(description: #function)
        
        var result: Result<(Data, URL), Error>?
        
        sut.fetch {
            result = $0
            myExpect.fulfill()
        }
        
        wait(for: [myExpect], timeout: 4)
        
        guard let unwrappedResult = result else {
            XCTFail()
            return
        }
        
        switch unwrappedResult {
        case  .success(let value):
            XCTAssertEqual(expectedURL, value.1)
        case .failure:
            XCTFail("expected success")
        }
    }
    
    // TODO: -
//    func test_useCacheOnFetch_ifThereIsKeyMatchingEntry_inCache() {
//        // GIVEN
//        let badURL = urlThatWillInvokeFailureBlock()
//        let (sut, cache) = makeSUT(inputURL: badURL, imageDataCache: CacheSpy())
//
//
//        cache.setObject(NSData(data: anyData()), forKey: badURL.asNSString)
//        let myExpect = expectation(description: #function)
//
//        sut.fetch { _ in myExpect.fulfill() }
//
//        wait(for: [myExpect], timeout: 5)
//
//        guard let object = cache.object(forKey: badURL.asNSString) else {
//            XCTFail()
//            return
//        }
//
//        // getting the customData will indicate that the cache was successfully accessed
//        XCTAssertEqual(object, CacheSpy.customData)
//    }
    
    
    func test_fetch_returnsFailureOnBadURL() {
        
    }
    
    private func makeSUT(inputURL: URL, imageDataCache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()) -> (RemoteDataFetcherWithCacheFallback, NSCache<NSString, NSData>) {
        
        let fetcher = RemoteDataFetcherWithCacheFallback(
            url: inputURL,
            imageDataCache: imageDataCache
        )
        return (fetcher, imageDataCache)
    }
    
    private func urlThatWillBeSuccessful() -> URL {
        guard let url = URL(string: "https://google.com/") else { fatalError() }
        return url
    }
    

    private func urlThatWillInvokeFailureBlock() -> URL {
        guard let url = URL(string: "https://google.com/") else { fatalError() }
        return url
    }

//    private class CacheSpy {
//        
//        static let customData = NSData(data: anyData())
//        
//        init() {
//            
//        }
//        
//        override func object(forKey key: NSString) -> NSData? {
//            _ = super.object(forKey: key)
//
//            if let _ = super.object(forKey: key) {
//                return NSData(data: anyData())
//            } else {
//                return nil
//            }
//        }
//        
//    }
}


private extension URL {
    var asNSString: NSString {
        return NSString(string: absoluteString)
    }
}
