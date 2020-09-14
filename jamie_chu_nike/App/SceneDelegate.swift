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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        startAppFlow(withWindowScene: windowScene)
    }
    
    private func startAppFlow(withWindowScene windowScene: UIWindowScene) {
        let myWindow = UIWindow(windowScene: windowScene)
        let viewModel = HomeViewModel(recordsfetcher: RemoteItunesAPI())
        let controller = HomeController(viewModel: viewModel)
        let root = UINavigationController(rootViewController: controller)
        let appCoordinator = AppCoordinator(navigationController: root, window: myWindow)

        controller.coordinatorDelegate = appCoordinator
        viewModel.delegate = controller
        appCoordinator.start()
    }
    
}

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
        let infoController = AlbumInfoViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(infoController, animated: true)
    }
    
}
