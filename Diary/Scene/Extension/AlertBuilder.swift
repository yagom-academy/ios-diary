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
    let completionHandler: (() -> Void)?
}

final class AlertBuilder {
    private var actions: [AlertAction] = []
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func setViewController(to viewController: UIViewController?) -> Self {
        self.viewController = viewController
        return self
    }
    
    func addAction(title: String, style: UIAlertAction.Style, action: (() -> Void)? = nil) -> Self {
        actions.append(AlertAction(title: title, style: style, completionHandler: action))
        return self
    }
    
    func show(title: String? = nil, message: String? = nil, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.completionHandler?()
            }
            alertController.addAction(alertAction)
        }
        
        viewController?.present(alertController, animated: true)
    }
}
