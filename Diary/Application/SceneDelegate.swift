//
//  Diary - SceneDelegate.swift
//  Created by Minseong, Lingo
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
    self.window = UIWindow(windowScene: windowScene)
    let rootViewController = DiaryViewController()
    self.window?.rootViewController = UINavigationController(
      rootViewController: rootViewController
    )
    self.window?.makeKeyAndVisible()
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    DiaryPersistentManager.shared.saveContext()
  }
}
