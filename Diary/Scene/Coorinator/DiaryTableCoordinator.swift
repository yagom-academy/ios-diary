//
//  DiaryTableCoordinator.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/30.
//

import UIKit

final class DiaryTableCoordinator: Coordinator {
    weak var viewController: UIViewController?
    
    func pushToDiaryDetail(_ diary: Diary) {
        let childCoordinator = DiaryDetailCoordinator()
        let childViewcontroller = DiaryDetailViewController(coordinator: childCoordinator, diary: diary)
        
        childViewcontroller.delegate = viewController as? DiaryDetailViewDelegate
        childCoordinator.viewController = childViewcontroller
        
        if Thread.isMainThread {
            viewController?.navigationController?.pushViewController(childViewcontroller, animated: true)
        } else {
            DispatchQueue.main.async {
                self.viewController?.navigationController?.pushViewController(childViewcontroller, animated: true)
            }
        }
    }
}
