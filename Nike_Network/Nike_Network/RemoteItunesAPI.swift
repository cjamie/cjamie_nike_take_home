//
//  RemoteItunesAPI.swift
//  Nike_Network
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

protocol ItunesRecordFetcher {
    func fetchDefaultRaw(router: URLRequestableHTTPRouter, completion: @escaping (Result<ItunesMonolith, Error>)->Void)
}

typealias URLRequestableHTTPRouter = URLRequestConvertible & HTTPRouter

class RemoteItunesAPI: ItunesRecordFetcher {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    private static let nikeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    private static let nikeItunesJsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(nikeDateFormatter)
        return decoder
    }()
    
    // MARK: - ItunesRecordFetcher
    
    func fetchDefaultRaw(router: URLRequestableHTTPRouter, completion: @escaping (Result<ItunesMonolith, Error>) -> Void) {
        do {
            let request = try router.asURLRequest()
            session.dataTask(with: request) {
                
                let processor: DecodableResultProcessor<ItunesMonolith> = DecodableResultProcessor(
                    rawResponse: ($0, $1, $2),
                    decoder: Self.nikeItunesJsonDecoder
                )
                
                Self.dispatch { completion(processor.process()) }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
            
    private static func dispatch(block: @escaping ()-> Void) {
        DispatchQueue.main.async(execute: block)
    }
}
