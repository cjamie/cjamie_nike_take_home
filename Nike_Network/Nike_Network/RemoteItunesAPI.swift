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
    private let session: Session
    private let processor: DecodableResultProcessor<ItunesMonolith> = {
        let nikeDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()

        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        decoder.dateDecodingStrategy = .formatted(formatter)

        return DecodableResultProcessor<ItunesMonolith>(decoder: decoder)
    }()

    // MARK: - Init
    
    public init(session: Session) {
        self.session = session
    }
    
    // MARK: - ItunesRecordFetcher
    
    public func fetchDefaultRaw(
        router: URLRequestableHTTPRouter,
        completion: @escaping (Result<ItunesMonolith, Error>) -> Void
    ) {
        do {
            session.dataTask(with: try router.asURLRequest()) { [weak self] data, response, error in
                guard let self = self else { return }
                completion(self.processor.process(rawResponse: (data, response, error)))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

public protocol Task {
    func resume()
}

extension URLSessionDataTask: Task {}

public protocol Session {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> Task
}


extension URLSession: Session {
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> Task {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
