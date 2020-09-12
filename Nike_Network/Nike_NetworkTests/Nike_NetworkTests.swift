//
//  Nike_NetworkTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class Nike_NetworkTests: XCTestCase {

    
    
    func test() {
        XCTFail()
    }
    
    struct MyHttpRouter: HTTPRouter {
        let method: String
        
        let host: String
        
        let scheme: String
        
        let path: String
        
        let parameters: [String : Any]
        
        let additionalHttpHeaders: [String : Any]
        
        func asURLRequest() throws -> URLRequest {
            guard let baseURL = baseURL else { throw NetworkingErrors.malformedURL }
            var request = URLRequest(url: baseURL)
            request.httpMethod = method
            additionalHttpHeaders.forEach { header in
                guard let value = header.value as? String else { return }
                request.addValue(value, forHTTPHeaderField: header.key)
            }
            return request

        }
    }
}


