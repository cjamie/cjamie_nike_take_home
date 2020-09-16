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

func anyIntArray(size: Int = 5) -> [Int] {
    return (0..<size).map { _ in .random(in: 1...20) }
}

func anyURL() -> URL {
    return URL(string: "https://google.com/\(anyRandomNonEmptyString())") ?? URL(fileReferenceLiteralResourceName: anyRandomNonEmptyString())
}

func anyRandomNonEmptyString() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<10).map{ _ in letters.randomElement()! })
}
