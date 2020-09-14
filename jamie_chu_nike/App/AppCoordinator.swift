//
//  AppCoordinator.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/14/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow

    // MARK: - Coordinator
    
    var children: [Coordinator]
    let navigationController: UINavigationController
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    // MARK: - Init
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.children = []
        self.window = window
    }
}

extension AppCoordinator: HomeControllerCoordinationDelegate {
    func homeController(_ controller: HomeController, fetchingDidFailWith error: Error) {
        let alert = UIAlertController(
            title: "Failed fetching",
            message: "some arbitrary message",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    func homeController(_ controller: HomeController, didSelectViewModel viewModel: AlbumInfoViewModel) {
        let infoController = AlbumInfoViewController(viewModel: viewModel, coordinationDelegate: self)
        navigationController.pushViewController(infoController, animated: true)
    }
    
}


extension AppCoordinator: AlbumInfoCoordinationDelegate {
    func albumInfoViewController(_ controller: AlbumInfoViewController, didTapAlbumButtonWith url: URL) {
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(
                title: "Failed to open URL: \(url.absoluteString)",
                message: ":(",
                preferredStyle: .alert
            )
            
            alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
            controller.present(alert, animated: true, completion: nil)

        }
    }
}
