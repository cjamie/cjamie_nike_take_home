//
//  TestUtilities.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest

func emptyDictionary() -> [String: String] {
    [:]
}

func emptyString() -> String {
    ""
}

func anyString() -> String{
    "anyString"
}

// MARK: - Attribution: https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
func anyRandomNonEmptyString() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<10).map{ _ in letters.randomElement()! })
}

func anyInt() -> Int {
    return 839249
}

func anyHost() -> String {
    "anyHost"
}

func anyScheme() -> String {
    "anyScheme"
}

func anyPath() -> String {
    "anyScheme"
}

// NOTE: - URLs will add include whitespace encoding if there are spaces
func anyStringWithoutSpaces() -> String {
    return "anyStringWithoutSpaces"
}
