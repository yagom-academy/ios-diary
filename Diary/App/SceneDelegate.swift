//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let diaryService = DiaryService(name: "Diary")

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let diaryListViewController = DiaryListViewController(diaryService: diaryService)
        let navigationController = UINavigationController(rootViewController: diaryListViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        do {
            try diaryService.saveDiary()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
