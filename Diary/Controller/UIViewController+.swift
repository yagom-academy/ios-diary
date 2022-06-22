//
//  UIViewController+.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/22.
//

import UIKit

extension UIViewController {
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)

        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
