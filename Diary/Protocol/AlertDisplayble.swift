//
//  AlertDisplayble.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/05.
//

import UIKit

protocol AlertDisplayable {
    func showAlert(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style)
}

extension AlertDisplayable where Self: UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   actions: [UIAlertAction],
                   preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alertController.addAction($0) }
        
        present(alertController, animated: true)
    }
}
