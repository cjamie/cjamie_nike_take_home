//
//  AlbumInfoViewController.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit

protocol AlbumInfoCoordinationDelegate: class {
    func albumInfoViewController(_ controller: AlbumInfoViewController, didTapAlbumButtonWith url: URL)
}

final class AlbumInfoViewController: UIViewController {
    private let viewModel: AlbumInfoViewModel
    private weak var coordinationDelegate: AlbumInfoCoordinationDelegate?
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "{albumNameLabel}"
        label.numberOfLines = 0
        label.backgroundColor = .purple
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "{artistNameLabel}"
        label.numberOfLines = 0
        label.backgroundColor = .purple
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let albumThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "{genreLabel}"
        label.numberOfLines = 0
        label.backgroundColor = .purple
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "{releaseDateLabel}"
        label.numberOfLines = 0
        label.backgroundColor = .purple
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "{copyrightLabel}"
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = .purple
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let albumPageOnItunesStoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap fast!", for: .normal)
        button.backgroundColor = .brown
        button.addTarget(self, action: #selector(didTapAlbumButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        setupViews()
        
        viewModel.artist.bind { [weak self] artistName in
            self?.artistNameLabel.text = artistName
        }
        viewModel.copyrightDescription.bind { [weak self] copyright in
            self?.copyrightLabel.text = copyright
        }
        viewModel.genre.bind { [weak self] genres in
            self?.genreLabel.text = genres
        }
        viewModel.nameOfAlbum.bind { [weak self] albumName in
            self?.albumNameLabel.text = albumName
        }
        viewModel.releaseDate.bind { [weak self] releaseDate in
            self?.releaseDateLabel.text = releaseDate
        }
        
        viewModel.thumbnailImage.bind { [weak self] imageURL in
            
            
//            if let data = self?.viewModel.imageDataCache.object(forKey: NSString(string: imageURL.absoluteString)) as Data? {
//                self?.albumThumbnailImageView.image = UIImage(data: data)
//            } else {
//                // TODO: - fetcher service to be added to viewmodel to retrieve
//            }
        }
        
    }
    
    @objc private func didTapAlbumButton(_ sender: UIButton) {
        coordinationDelegate?.albumInfoViewController(self, didTapAlbumButtonWith: viewModel.albumURL)
        
    }
    
    
    // MARK: - Init
    
    init(viewModel: AlbumInfoViewModel, coordinationDelegate: AlbumInfoCoordinationDelegate) {
        self.viewModel = viewModel
        self.coordinationDelegate = coordinationDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }

    // MARK: - Helpers
    
    private func setupViews() {
        
        infoStackView.addArrangedSubviews([albumNameLabel, artistNameLabel, albumThumbnailImageView, genreLabel, releaseDateLabel, copyrightLabel])
        view.addSubview(mainScrollView)
        mainScrollView.addSubviews([infoStackView,albumPageOnItunesStoreButton])
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 16),
            infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumThumbnailImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumThumbnailImageView.heightAnchor.constraint(equalTo: albumThumbnailImageView.widthAnchor, multiplier: 2),
            albumPageOnItunesStoreButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20),
            albumPageOnItunesStoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            albumPageOnItunesStoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumPageOnItunesStoreButton.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -20),
        ])
    }
}
