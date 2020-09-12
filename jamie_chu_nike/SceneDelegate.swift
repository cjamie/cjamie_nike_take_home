//
//  SceneDelegate.swift
//  jamie_chu_nike
//
//  Created by Jamie Chu on 9/11/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

}

