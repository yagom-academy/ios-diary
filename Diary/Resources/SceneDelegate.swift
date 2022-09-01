//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let diaryListViewController = DiaryListViewController()
        let navigationController = UINavigationController(rootViewController: diaryListViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let navigationViewController = window?.rootViewController as? UINavigationController
        else { return }
        
        let topViewContoller = navigationViewController.topViewController
        
        switch topViewContoller {
        case let viewController as DiaryRegisterViewController:
            viewController.saveData()
        case let viewController as DiaryDetailViewController:
            viewController.saveData()
        default:
            break
        }
    }
}
