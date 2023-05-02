//
//  AlertImplementation.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct AlertMaker: AlertFactoryService {
    func make(for data: AlertControllerData) -> UIAlertController {
        let alertController = UIAlertController(title: data.title,
                                                message: data.message,
                                                preferredStyle: data.style)
        let actionDataList = data.actionDataList
        
        actionDataList.forEach { actionData in
            let action = UIAlertAction(
                title: actionData.actionTitle,
                style: actionData.actionStyle) { _ in
                    actionData.completion?()
                }
            
            alertController.addAction(action)
        }
        
        return alertController
    }
}
