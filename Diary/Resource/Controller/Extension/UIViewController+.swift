//
//  UIViewController+.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

extension UIViewController {
    func showAlertController(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: AlertNamespace.confirm,
                                                  style: .default,
                                                  handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    enum AlertNamespace {
        static let confirm = "확인"
        static let jsonErrorMessage = "데이터 읽기 오류"
        static let none = ""
    }
}
