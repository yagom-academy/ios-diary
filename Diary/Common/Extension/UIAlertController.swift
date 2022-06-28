//
//  UIAlertController.swift
//  Diary
//
//  Created by 조민호 on 2022/06/28.
//

import UIKit

extension UIAlertController {
    func showDeleteAlert(presentedViewController: UIViewController, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(
            title: AppConstants.deleteAlertTitle,
            message: AppConstants.deleteAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: AppConstants.cancelActionTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: AppConstants.deleteActionTitle, style: .destructive, handler: handler)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        presentedViewController.present(alert, animated: true)
    }
    
    func showConfirmAlert(
        title: String,
        message: String,
        presentedViewController: UIViewController,
        handler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: AppConstants.confirmActionTitle, style: .default) { _ in
            handler?()
        }
        alert.addAction(confirmAction)
        presentedViewController.present(alert, animated: true)
    }
}
