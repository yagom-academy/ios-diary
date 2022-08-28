//
//  UIViewController + extension.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/28.
//

import UIKit

extension UIViewController {
    func showErrorAlert(error: CoreDataError) {
        let alertController = UIAlertController(
            title: "⚠️",
            message: error.errorMessage,
            preferredStyle: .alert
        )
        let okButton = UIAlertAction(
            title: "확인",
            style: .default,
            handler: nil
        )
        alertController.addAction(okButton)
        
        self.present(
            alertController,
            animated: true
        )
    }
}
