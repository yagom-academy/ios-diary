//
//  UIAlertController+.swift
//  Diary
//
//  Created by Erick on 2023/08/31.
//

import UIKit

extension UIAlertController {
    static func customAlert(alertTile: String?, alertMessage: String?, preferredStyle: UIAlertController.Style, alertActions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: preferredStyle)
        
        alertActions.forEach {
            alert.addAction($0)
        }
        
        return alert
    }
    
    static func failedAlert(failMessage: String?) -> UIAlertController {
        let alertAction = UIAlertAction(title: "확인", style: .cancel)
        let alert = UIAlertController.customAlert(alertTile: "실패", alertMessage: failMessage, preferredStyle: .alert, alertActions: [alertAction])
        
        return alert
    }
}
