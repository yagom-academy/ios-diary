//
//  DiaryProtocol.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/21.
//

import UIKit

protocol DiaryProtocol: ActivityProtocol, AlertProtocol {}

protocol ActivityProtocol: UIViewController {}

extension ActivityProtocol {
    func showActivity(title: String?) {
        guard let title = title else {
            return
        }
            
        let activityViewController = UIActivityViewController(
            activityItems: [title],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
    }
}

protocol AlertProtocol: UIViewController {}

extension AlertProtocol {
    func showActionSheet(actions: [UIAlertAction]) {
        let sheet = AlertBuilder.shared
            .setType(.actionSheet)
            .setActions(actions)
            .build()
        
        present(sheet, animated: true)
    }
    
    func showAlert(title: String, message: String? = nil, actions: [UIAlertAction]? = nil) {
        let alert = AlertBuilder.shared
            .setTitle(title)
            .setMessage(message)
            .setType(.alert)
            .setActions(actions)
            .build()
        
        present(alert, animated: true)
    }
    
    func makeAction(title: String, style: UIAlertAction.Style, completionHendler: (() -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style) { _ in
            completionHendler?()
        }
        
        return action
    }
}

final class AlertBuilder {
    struct Product {
        var title: String?
        var message: String?
        var type: UIAlertController.Style = .alert
        var actions: [UIAlertAction] = []
    }
    
    static private let alertBuilder = AlertBuilder()
    static private var product = Product()
    
    static var shared: AlertBuilder {
        product = Product()
        return alertBuilder
    }
    
    private init() { }
    
    func setTitle(_ title: String) -> Self {
        Self.product.title = title
        
        return self
    }
    
    func setMessage(_ message: String?) -> Self {
        Self.product.message = message
        
        return self
    }
    
    func setType(_ type: UIAlertController.Style) -> Self {
        Self.product.type = type
        
        return self
    }
    
    func setActions(_ actions: [UIAlertAction]?) -> Self {
        guard let actions = actions else {
            return self
        }

        actions.forEach {
            Self.product.actions.append($0)
        }
        
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(
            title: AlertBuilder.product.title,
            message: AlertBuilder.product.message,
            preferredStyle: AlertBuilder.product.type
        )
        
        AlertBuilder.product.actions.forEach {
            alert.addAction($0)
        }
        
        return alert
    }
}
