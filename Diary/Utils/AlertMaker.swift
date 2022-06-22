//
//  AlertMaker.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/21.
//

import UIKit

struct AlertMaker {
    let viewController: UIViewController
    
    func makeErrorAlert(error: Error, handler: ((UIAlertAction) -> Void)? = nil) {
        let checkedError = error as? ErrorAlertProtocol ?? UnknownError.unknownError
        let alertContoller = UIAlertController(title: checkedError.alertTitle,
                                               message: checkedError.alertMessage,
                                               preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "확인", style: .default, handler: handler)
        alertContoller.addAction(alertButton)
        
        viewController.present(alertContoller, animated: true)
    }
    
    func makeAlert(title: String, message: String, buttons: [UIAlertAction]) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        _ = buttons.map { button in
            alertContoller.addAction(button)
        }
        
        viewController.present(alertContoller, animated: true)
    }
    
    func makeActionSheet(buttons: [UIAlertAction]) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        _ = buttons.map { button in
            actionSheet.addAction(button)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelButton)
        
        viewController.present(actionSheet, animated: true)
    }
}
