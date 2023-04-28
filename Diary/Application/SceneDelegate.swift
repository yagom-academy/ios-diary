//
//  SceneDelegate.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: DiaryListViewController())
        window?.makeKeyAndVisible()
    }
}
