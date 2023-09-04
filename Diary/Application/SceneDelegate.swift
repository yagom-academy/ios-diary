//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let persistance: Persistance = Persistance()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: MainViewController(persistance: persistance))
        window?.backgroundColor = .systemBackground
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //코어데이터 저장
    }
}
