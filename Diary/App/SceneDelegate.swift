//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "Diary")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let diaryListViewController = DiaryListViewController(container: persistentContainer)
        let navigationController = UINavigationController(rootViewController: diaryListViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
