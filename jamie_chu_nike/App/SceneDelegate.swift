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
        let fetcher = MainThreadDecorator(RemoteItunesAPI(session: URLSession.shared))
        let viewModel = HomeViewModel(recordsfetcher: fetcher)
        let controller = HomeController(viewModel: viewModel)
        let root = UINavigationController(rootViewController: controller)
        let appCoordinator = AppCoordinator(navigationController: root, window: myWindow)

        self.appCoordinator = appCoordinator
        
        controller.coordinatorDelegate = appCoordinator
        viewModel.delegate = controller
        appCoordinator.start()
    }
    
    private var appCoordinator: AppCoordinator?
    
}

final class MainThreadDecorator: ItunesRecordFetcher {
    private let decoratee: ItunesRecordFetcher

    init(_ decoratee: ItunesRecordFetcher) {
        self.decoratee = decoratee
    }

    func fetchDefaultRaw(
        router: URLRequestableHTTPRouter,
        completion: @escaping (Result<ItunesMonolith, Error>) -> Void
    ) {
        decoratee.fetchDefaultRaw(router: router) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
}
