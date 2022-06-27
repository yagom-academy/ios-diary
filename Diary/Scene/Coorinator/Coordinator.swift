//
//  Coordinator.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/27.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
}

final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(_ persistentManager: PersistentManager) {
        let diaryTableViewController = DiaryTableViewController.instance(persistentManager: persistentManager)
        diaryTableViewController.coordinator = self
        
        if Thread.isMainThread == false {
            DispatchQueue.main.async {
                self.navigationController.pushViewController(diaryTableViewController, animated: false)
            }
        } else {
            navigationController.pushViewController(diaryTableViewController, animated: false)
        }
    }
    
    func pushDetailViewController(diary: Diary, delegate: DiaryDetailViewDelegate?) {
        let detailViewController = DiaryDetailViewController.instance(diary: diary)
        detailViewController.delegate = delegate
        detailViewController.coordinator = self
        
        if Thread.isMainThread == false {
            DispatchQueue.main.async {
                self.navigationController.pushViewController(detailViewController, animated: true)
            }
        } else {
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popDetailViewController() {
        if Thread.isMainThread == false {
            DispatchQueue.main.async {
                self.navigationController.popViewController(animated: true)
            }
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
