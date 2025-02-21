//
//  SceneDelegate.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemGray6
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
    }
}
