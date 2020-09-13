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
