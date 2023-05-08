//
//  Diary - SceneDelegate.swift
//  Created by Rowan, Harry. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: DiaryListViewController())
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let navigationController = window?.rootViewController as? UINavigationController,
              let topViewController = navigationController.topViewController,
              let diaryContentViewController = topViewController as? DiaryContentViewController
        else { return }
        
        diaryContentViewController.updateDiary()
    }
}
