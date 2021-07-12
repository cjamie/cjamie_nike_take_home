//
//  RemoteItunesAPI.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

public protocol ItunesRecordFetcher {
    func fetchDefaultRaw(router: URLRequestableHTTPRouter, completion: @escaping (Result<ItunesMonolith, Error>)->Void)
}

public typealias URLRequestableHTTPRouter = URLRequestConvertible & HTTPRouter

public class RemoteItunesAPI: ItunesRecordFetcher {
    private let session: URLSession
    private let processor: DecodableResultProcessor<ItunesMonolith>

    // MARK: - Init
    
    public init(session: URLSession, processor: DecodableResultProcessor<ItunesMonolith>) {
        self.session = session
        self.processor = processor
    }
    
    // MARK: - ItunesRecordFetcher
    
    public func fetchDefaultRaw(
        router: URLRequestableHTTPRouter,
        completion: @escaping (Result<ItunesMonolith, Error>) -> Void
    ) {
        do {
            session.dataTask(with: try router.asURLRequest()) { [weak self] data, response, error in
                guard let self = self else { return }

                Self.dispatch {
                    completion(self.processor.process(rawResponse: (data, response, error)))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Helpers
    
    private static func dispatch(block: @escaping ()-> Void) {
        DispatchQueue.main.async(execute: block)
    }
}
