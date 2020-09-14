//
//  AppTestUtilities.swift
//  jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

private enum MyError: Error {
    case first
}

func anySwiftError() -> Error {
    return MyError.first
}
