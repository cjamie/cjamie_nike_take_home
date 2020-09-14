//
//  Array+.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

// TODO: - make array access safe
// MARK: - Attribution: - https://www.hackingwithswift.com/example-code/language/how-to-make-array-access-safer-using-a-custom-subscript
extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
