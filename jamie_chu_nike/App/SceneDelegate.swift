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


        let decoder: JSONDecoder = {
            let nikeDateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                return formatter
            }()

            let decoder = JSONDecoder()

            decoder.dateDecodingStrategy = .formatted(nikeDateFormatter)
            return decoder
        }()

        let processor = DecodableResultProcessor<ItunesMonolith>(decoder: decoder)

        let fetcher = RemoteItunesAPI(session: .shared, processor: processor)
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
