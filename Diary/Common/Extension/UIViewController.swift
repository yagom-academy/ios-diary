//
//  UIViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/21.
//

import UIKit

extension UIViewController {
    func showAlert(handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(
            title: AppConstants.deleteAlertTitle,
            message: AppConstants.deleteAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: AppConstants.cancelActionTitle, style: .cancel)
        let removeAction = UIAlertAction(title: AppConstants.deleteActionTitle, style: .destructive, handler: handler)
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: AppConstants.confirmActionTitle, style: .default) { _ in
            handler?()
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    func showActivityView(data: DiaryEntity) {
        let textToShare: [Any] = [
            ShareActivityItemSource(
                title: data.title ?? AppConstants.noTitle,
                text: data.createdAt.formattedString)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension UIViewController {
    func topViewController() -> UIViewController? {
        if let presented = self.presentedViewController {
            return presented.topViewController()
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topViewController()
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topViewController() ?? tab
        }
        
        return self
    }
}
