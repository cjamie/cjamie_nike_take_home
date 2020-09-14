//
//  HomeCell.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit

final class HomeCell: UITableViewCell {
    
    // Consideration: - https://medium.com/bleeding-edge/nicer-reuse-identifiers-with-protocols-in-swift-97d18de1b2df
    static let reuseIdentifier = "HomeCell"
    
    // TODO: - also needs a service for fetching UIImager
    private var viewModel: AlbumCellViewModel?
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "{some placeholder}"
        label.numberOfLines = 0
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "{some placeholder}"
        label.numberOfLines = 0
        label.backgroundColor = .green
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let albumThumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()
    
    // MARK: - Public API

    func bind(model: AlbumCellViewModel) {
        self.viewModel = model
        
        model.artist.bind { [weak self] artistName in
            self?.artistNameLabel.text = artistName
        }
        
        model.nameOfAlbum.bind { [weak self] albumName in
            self?.albumNameLabel.text = albumName
        }
        
        model.thumbnailImage.bind { imageURL in
            // TODO: - fetcher.fetch(imageURL) or something like there here (also need to resolve tableview issues with images)
                        
        }
    }
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        labelStack.addArrangedSubviews([self.albumNameLabel, self.artistNameLabel])

        addSubviews([labelStack, albumThumbnailImageView])
        backgroundColor = .gray
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            labelStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            labelStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumThumbnailImageView.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: 16),
            albumThumbnailImageView.centerXAnchor.constraint(equalTo: labelStack.centerXAnchor),
            albumThumbnailImageView.widthAnchor.constraint(equalToConstant: 100),
            albumThumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            albumThumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
