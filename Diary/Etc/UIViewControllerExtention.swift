//
//  UIViewControllerExtention.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/02.
//

import UIKit

extension UIViewController {
    func showFailAlert(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: "데이터 로딩 실패 \n \(error.localizedDescription)",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
