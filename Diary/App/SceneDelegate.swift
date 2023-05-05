//
//  Diary - SceneDelegate.swift
//  Created by SeHong.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootViewController = DiaryListViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let navigationController = window?.rootViewController as? UINavigationController,
              let topViewController = navigationController.topViewController,
              let diaryDetailViewController = topViewController as? DiaryDetailViewController else { return }
        
        diaryDetailViewController.saveOrUpdateDiary()
    }
    
}
