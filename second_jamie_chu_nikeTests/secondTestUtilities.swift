//
//  secondTestUtilities.swift
//  second_jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest

private enum MyError: Error {
    case first
}

func anySwiftError() -> Error {
    return MyError.first
}

func anyIntArray() -> [Int] {
    return (0..<5).map { _ in .random(in: 1...20) }
}
