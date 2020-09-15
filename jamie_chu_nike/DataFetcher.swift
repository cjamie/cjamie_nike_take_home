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
        if let imageDataFromCache = imageDataCache.object(forKey: NSString(string: url.absoluteString)) as Data? {
            print("-=- using cache")
            completion(.success((imageDataFromCache, url)))
        } else {
            session.dataTask(with: url) { [weak self] in
                guard let self = self else { return }
                let result = DataResultProcessor(rawResponse: ($0, $1, $2)).result
                print("-=- 2")
                switch result {
                case .failure(let error):
                    print("-=- 3")
                    completion(.failure(error))
                case .success(let data):
                    print("-=- 4")

                    self.imageDataCache.setObject(
                        NSData(data: data),
                        forKey: NSString(string: self.url.absoluteString)
                    )
                    DispatchQueue.main.async {
                        completion(.success((data, self.url)))
                    }
                }
                
            }.resume()
            
//                guard let self = self else {
//                    return
//                }
//                guard let data = data, let image = UIImage(data: data) else {
//                    return
//                }
//
//                guard let cachedURL = self._imageURL, cachedURL == imageURL else {
//                    return
//                }
//
//                model.imageDataCache.setObject(NSData(data: data), forKey: NSString(string: imageURL.absoluteString))
//
//                DispatchQueue.main.async {
//                    self.albumThumbnailImageView.image = image
//                }
//            }.resume()
        }
        
        
//        session.dataTask(with: url) {
//            let processor = DataResultProcessor(rawResponse: ($0, $1, $2))
//            completion(processor.result)
//        }.resume()
    }
    
}

protocol DataCacheUtilizer {
    var imageDataCache: NSCache<NSString, NSData> { get }
}
