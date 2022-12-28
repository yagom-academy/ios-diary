//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = UINavigationController(rootViewController: DiaryListViewController())
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let topViewController = UIApplication.topViewController(rootViewController) as? DiaryViewController {
            topViewController.updateCoreDataIfNeeded()
        }
    }
}
