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

    private let viewModel: HomeViewModel
    private let coordinator: Coordinator
    
    private let jamiesPretentiousLabel: UILabel = {
        let label = UILabel()
        label.text = " Jamie's Itunes App!!! ( ͡° ͜ʖ ͡°) "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.textColor = .white
        return label
    }()
    
    private lazy var albumTableView: UITableView = {
        let tableview = UITableView()
        print("-=- setting delegate \(self.viewModel)")
        tableview.dataSource = self.viewModel
        tableview.delegate = self.viewModel
        tableview.backgroundColor = .blue
        
        tableview.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        setupView()
        
        print("-=- did load")
        viewModel.albumCellModels.bind { [weak self] values in
            print("-=- bind \(values.count)")
            self?.albumTableView.reloadData() }
        viewModel.start()
    }
    
    init(viewModel: HomeViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }
    
    // MARK: - Helpers
    
    private func setupView() {
        view.addSubviews([albumTableView, jamiesPretentiousLabel])
        NSLayoutConstraint.activate([
            jamiesPretentiousLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            jamiesPretentiousLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumTableView.topAnchor.constraint(equalTo: jamiesPretentiousLabel.bottomAnchor, constant: 16),
            albumTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            albumTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            albumTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension HomeController: HomeViewModelDelegate {
    
    func homeViewModel(_ homeModel: HomeViewModel, fetchingDidFailWith error: Error) {
        // TODO: - handle want to do when we try to fetch but fail
    }
    
    func homeViewModel(_ homeModel: HomeViewModel, didSelectRowWith viewModel: AlbumInfoViewModel) {
        
        // TODO: - delegate this to coordinator

        let infoController = AlbumInfoViewController(viewModel: viewModel, coordinator: NANCoordinator())
        navigationController?.pushViewController(infoController, animated: true)
    }
}
