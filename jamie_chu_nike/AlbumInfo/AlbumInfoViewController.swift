//
//  AlbumInfoViewController.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit

protocol AlbumInfoViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<URL> { get }
    var genre: Box<[String]> { get }
    var releaseDate: Box<String> { get }
    var copyrightDescription: Box<String> { get }
}

struct AlbumInfoViewModelImpl: AlbumInfoViewModel{
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<URL>
    let genre: Box<[String]>
    let releaseDate: Box<String>
    let copyrightDescription: Box<String>
}

class AlbumInfoViewController: UIViewController {
    let viewModel: AlbumInfoViewModel
    let coordinator: Coordinator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
    }
    
    init(viewModel: AlbumInfoViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }

}
