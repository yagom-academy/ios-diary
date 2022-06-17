//
//  AlertBuilder.swift
//  Diary
//
//  Created by dudu, papri on 17/06/2022.
//

import UIKit

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: (() -> Void)?
}

final class AlertBuilder {
    var alertActions: [AlertAction] = []
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func addAlertAction(title: String, style: UIAlertAction.Style, action: (() -> Void)? = nil) -> Self {
        alertActions.append(AlertAction(title: title, style: style, action: action))
        return self
    }
    
    func show(title: String? = nil, message: String? = nil, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertActions.forEach { alertAction in
            let alertAction = UIAlertAction(title: alertAction.title, style: alertAction.style) { _ in
                alertAction.action?()
            }
            alertController.addAction(alertAction)
        }
        viewController?.present(alertController, animated: true)
    }
}
