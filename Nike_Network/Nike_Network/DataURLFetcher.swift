//
//  DataURLFetcher.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/15/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

public protocol DataURLFetcher {
    func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void)
}

// TODO: - move this to the SDK, and re-privatize the data fetcher
public class RemoteDataFetcherWithCacheFallback: DataURLFetcher, DataCacheUtilizer {
        
    private let session: URLSession
    let url: URL

    public init(session: URLSession = .shared, url: URL, imageDataCache: NSCache<NSString, NSData>) {
        self.session = session
        self.url = url
        self.imageDataCache = imageDataCache
    }

    // MARK: - DataCacheUtilizer
    
    let imageDataCache: NSCache<NSString, NSData>
    
    // MARK: - DataURLFetcher
    
    public func fetch(completion: @escaping (Result<(Data, URL), Error>) -> Void) {
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
                    // TODO: - need tests to capture behavior that this goes back to main thread
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
