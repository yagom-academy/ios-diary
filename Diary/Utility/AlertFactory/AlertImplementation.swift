//
//  AlertImplementation.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct AlertImplementation: AlertFactoryService {
    func makeAlert(for alertData: AlertViewData) -> UIAlertController {
        let alertController = UIAlertController(title: alertData.title,
                                                message: alertData.message,
                                                preferredStyle: alertData.style)
        
        if alertData.enableOkAction {
            let okAction = UIAlertAction(
                title: alertData.okActionTitle,
                style: alertData.okActionStyle) { _ in
                    alertData.completion?()
                }
            
            alertController.addAction(okAction)
        }
        
        if alertData.enableCancelAction {
            let cancelAction = UIAlertAction(
                title: alertData.cancelActionTitle,
                style: alertData.cancelActionStyle) { _ in
                    alertData.completion?()
                }
            
            alertController.addAction(cancelAction)
        }
        
        return alertController
    }
}
