//
//  Box.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    // MARK: - Public API
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(listener: Listener? = nil) {
        self.listener = listener
        listener?(value)
    }
    
    // MARK: - Init
    
    init(_ value: T) {
        self.value = value
    }
    
}
