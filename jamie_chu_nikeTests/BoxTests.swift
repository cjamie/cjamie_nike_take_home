//
//  BoxTests.swift
//  jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation
import XCTest

class BoxTests: XCTestCase {
    
    func test_cellModelBinding() {
        let myBox: Box<[AlbumCellViewModel]> = Box([])
        
        let model = FakeCellModelListener(box: myBox)
        XCTAssert(model._capturedClosures.isEmpty)
        model.bind()
        XCTAssert(model._capturedClosures.count == 1)
    }
    
    class FakeCellModelListener {
        private let boxToListenTo: Box<[AlbumCellViewModel]>
        
        var _capturedClosures: [([AlbumCellViewModel])->Void] = []
        
        init(box: Box<[AlbumCellViewModel]>) {
            self.boxToListenTo = box
        }
        
        func bind() {
            boxToListenTo.bind { models in
                self._capturedClosures.append { models in }
            }
        }
    }

}
