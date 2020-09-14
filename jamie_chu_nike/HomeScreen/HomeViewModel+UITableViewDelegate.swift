//
//  HomeViewModel+UITableViewDelegate.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit

// TODO: - these are placeholders
extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumCellModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifier) as? HomeCell else {
            fatalError("bad cell")
        }
        
        cell.bind(model: albumCellModels.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        guard let viewModel = albumInfoViewModel(at: indexPath.row) else { return }
        delegate?.homeViewModel(self, didSelectRowWith: viewModel)
    }
    
}
