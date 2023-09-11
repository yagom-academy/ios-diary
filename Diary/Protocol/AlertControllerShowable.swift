//
//  AlertControllerShowable.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/11.
//

import UIKit

protocol AlertControllerShowable where Self: UIViewController {
    func showAlertController(title: String?,
                             message: String?,
                             style: UIAlertController.Style,
                             actions: [UIAlertAction])
}

extension AlertControllerShowable {
    func showAlertController(title: String? = nil,
                             message: String? = nil,
                             style: UIAlertController.Style = .actionSheet,
                             actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
}
