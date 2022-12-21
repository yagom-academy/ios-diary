//
//  DateFormatter+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/21.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
