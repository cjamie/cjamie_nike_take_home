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

    private let fetcherAPI: ItunesRecordFetcher
//    let viewModel: HomeViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("-=- vdl")
        
        view.backgroundColor = .yellow
        
//        fetcherAPI.fetchDefaultRaw(router: ITunesRouter.nikeDefault) { raw in
//            print("-=- hello, we fetched \(raw)")
//        }
    }

    // MARK: - Attribution: - https://stackoverflow.com/questions/56089897/programmatically-initialize-viewcontroller
    
    init(fetcherAPI: ItunesRecordFetcher) {
        self.fetcherAPI = fetcherAPI

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }

}
