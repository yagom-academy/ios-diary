//
//  UIViewController+Extension.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/23.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(_ error: (Error)) {
        let errorAlert = UIAlertController(
            title: Alert.errorAlertTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: Alert.confirmActionTitle,
            style: .default
        )
        
        errorAlert.addAction(confirmAction)
        
        present(errorAlert, animated: true)
    }
}
