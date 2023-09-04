//
//  UIViewController+.swift
//  Diary
//
//  Created by Mary & Whales on 9/3/23.
//

import UIKit

extension UIViewController {
    func presentAlertWith(title: String?,
                          message: String?,
                          actionConfigs: (title: String?,
                                          style: UIAlertAction.Style,
                                          handler: ((UIAlertAction) -> Void)?)...) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        for config in actionConfigs {
            let action = UIAlertAction(title: config.title,
                                       style: config.style,
                                       handler: config.handler)
            alertController.addAction(action)
        }

        present(alertController, animated: true)
    }
}
