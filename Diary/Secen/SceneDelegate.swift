//
//  Diary - SceneDelegate.swift
//  Created by Quokka Taeangel. 
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
      window = UIWindow(windowScene: windowScene)
      window?.rootViewController = UINavigationController(rootViewController: MainViewController())
      window?.makeKeyAndVisible()
  }
}
