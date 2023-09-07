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
    
    func presentCheckDeleteAlert(completion: @escaping () -> Void) {
        let deleteHandler: (UIAlertAction) -> Void = { _ in
            completion()
        }
        
        presentAlertWith(title: "진짜요?",
                         message: "정말로 삭제하시겠어요?",
                         preferredStyle: .alert,
                         actionConfigs: ("취소", .cancel, nil),
                                        ("삭제", .destructive, deleteHandler))
    }
    
    func presentActivityView(shareItem: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [shareItem],
            applicationActivities: [])

        present(activityViewController, animated: true)
    }
}
