//
//  DataFetcher.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation
import Nike_Network

protocol DataFetcher {
    func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void)
}

class RemoteDataFetcherWithCacheFallback: DataFetcher, DataCacheUtilizer {
        
    private let session: URLSession
    private let url: URL

    init(session: URLSession, url: URL, imageDataCache: NSCache<NSString, NSData>) {
        self.session = session
        self.url = url
        self.imageDataCache = imageDataCache
    }

    // MARK: - DataCacheUtilizer
    
    let imageDataCache: NSCache<NSString, NSData>
    
    // MARK: - DataFetcher
    
    func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
        if let imageDataFromCache = imageDataCache.object(forKey: NSString(string: url.absoluteString)) as Data?, imageDataFromCache != Data() {
            completion(.success((imageDataFromCache, url)))
        } else {
            session.invalidateAndCancel()
            session.dataTask(with: url) { [weak self] in
                guard let self = self else { return }
                let result = DataResultProcessor(rawResponse: ($0, $1, $2)).result
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    self.imageDataCache.setObject(
                        NSData(data: data),
                        forKey: NSString(string: self.url.absoluteString)
                    )
                    // TODO: - need tests to confirm this goes back to main thread
                    DispatchQueue.main.async {
                        completion(.success((data, self.url)))
                    }
                }
                
            }.resume()
        }
    }
    
}

protocol DataCacheUtilizer {
    var imageDataCache: NSCache<NSString, NSData> { get }
}
