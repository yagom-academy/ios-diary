//
//  UIViewController+.swift
//  Diary
//
//  Created by Mary & Whales on 9/3/23.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style,
                      actionConfigs: (title: String?,
                                      style: UIAlertAction.Style,
                                      handler: ((UIAlertAction) -> Void)?)...) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        
        for config in actionConfigs {
            let action = UIAlertAction(title: config.title,
                                       style: config.style,
                                       handler: config.handler)
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
    
    func presentCheckDeleteAlert(deleteHandler: @escaping (UIAlertAction) -> Void) {
        presentAlert(title: "checkDeleteAlertTitle".localized,
                     message: "checkDeleteAlertMessage".localized,
                     preferredStyle: .alert,
                     actionConfigs: ("checkDeleteAlertCancelAction".localized, .cancel, nil),
                     ("checkDeleteAlertAction".localized, .destructive, deleteHandler))
    }
}
