//
//  HomeController.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/11/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit
import Nike_Network

final class HomeController: UIViewController {

//    private let viewModel: HomeViewModel
    private let coordinator: Coordinator
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("-=- vdl")
        
        view.backgroundColor = .yellow
    }

    // MARK: - Attribution: - https://stackoverflow.com/questions/56089897/programmatically-initialize-viewcontroller
    
//    init(viewModel: HomeController, coordinator: Coordinator) {
////        self.viewModel = viewModel
//        self.coordinator = coordinator
//        super.init(nibName: nil, bundle: nil)
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }

}
