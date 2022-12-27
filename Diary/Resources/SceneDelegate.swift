//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let controller = DiaryListViewController()
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        backgroundDiaryUpdate()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        backgroundDiaryUpdate()
    }
    
    private func backgroundDiaryUpdate() {
        guard let rootViewController = window?.rootViewController as? UINavigationController,
              let topViewController = rootViewController.topViewController as? DiaryDetailViewController
        else {
            return
        }
        
        topViewController.updateAndCreateData()
    }
}
