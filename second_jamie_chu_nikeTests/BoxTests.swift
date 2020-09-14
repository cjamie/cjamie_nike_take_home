//
//  BoxTests.swift
//  second_jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation
import XCTest
@testable import jamie_chu_nike

class BoxTests: XCTestCase {
        
    func test_bindCall_invokesListenerOnce() {
        // GIVEN
        let (_, spy) = makeSUT()
        var capturedArrays: [[Int]] = []
        
        XCTAssertEqual(capturedArrays, [])

        spy.bind { capturedArrays.append($0) }
        
        
        // WHEN
        
        //THEN
        XCTAssertEqual(capturedArrays, [[]])
    }
    
    func test_valueChanges_invokesListener_whenChanged_ifAListenerIsSet() {
        // GIVEN
        let (sut, spy) = makeSUT()
        var capturedArrays: [[Int]] = []
        spy.bind { capturedArrays.append($0) }
        XCTAssertEqual(capturedArrays, [[]])

        
        // WHEN
        let newArrayValue = anyIntArray()
        sut.value = newArrayValue
        
        //THEN
        XCTAssertEqual(capturedArrays, [[],newArrayValue])
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (Box<[Int]>, BoxListenerSpy){
        let sut: Box<[Int]> = Box([])
        let spy = BoxListenerSpy(box: sut)
        return (sut, spy)
    }
    
    private typealias IntArrayClosure = ([Int]) -> Void
    
    private class BoxListenerSpy {
        private let boxToListenTo: Box<[Int]>
        
        init(box: Box<[Int]>) {
            self.boxToListenTo = box
        }
        
        func bind(input: @escaping IntArrayClosure) {
            boxToListenTo.bind { boxCurrentValue in
                input(boxCurrentValue)
            }
        }
    }

}
