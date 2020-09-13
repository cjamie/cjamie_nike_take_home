//
//  NetworkingErrorTests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

class NetworkingErrorTests: XCTestCase {

    func test_nonMatchingTypes_areNeverEquatable() {
        XCTAssertNotEqual(
            NetworkingError.malformedURL,
            NetworkingError.swift(anySwiftError())
        )
    }

}
