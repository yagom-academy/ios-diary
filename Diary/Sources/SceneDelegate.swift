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
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        let mainViewController = DiaryListTableViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
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
        guard let navigationViewController = window?.rootViewController as? UINavigationController else { return }
        guard let diaryRegisterViewController =
                navigationViewController.topViewController
                as? DetailDiaryViewController else { return }

        if !diaryRegisterViewController.textView.text.isEmpty && diaryRegisterViewController.isExist == false {
            diaryRegisterViewController.create(content: diaryRegisterViewController.getProcessedContent())
        } else if !diaryRegisterViewController.textView.text.isEmpty && diaryRegisterViewController.isExist == true {
            diaryRegisterViewController.update(
                entity: diaryRegisterViewController.content ?? DiaryContents(),
                content: diaryRegisterViewController.getProcessedContent()
            )
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
