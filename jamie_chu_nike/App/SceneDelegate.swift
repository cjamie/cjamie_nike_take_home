//
//  SceneDelegate.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/11/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit
import Nike_Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // TODO: Coordinator, and viewModel
        
        window?.rootViewController = {
            let viewModel = HomeViewModel(recordsfetcher: RemoteItunesAPI())
            let controller = HomeController(viewModel: viewModel, coordinator: NANCoordinator())
            let root = UINavigationController(rootViewController: controller)
            viewModel.delegate = controller
            return root
        }()
        
        window?.makeKeyAndVisible()
    }

}

// TODO: - create AppCoordinator
class NANCoordinator: Coordinator {
    var children: [Coordinator] = []
        
    let navigationController: UINavigationController = UINavigationController()
    
    func start() {
        
    }
}
