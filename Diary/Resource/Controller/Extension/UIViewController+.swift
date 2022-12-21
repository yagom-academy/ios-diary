//
//  UIViewController+.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: AlertNamespace.confirm,
                                                  style: .default,
                                                  handler: { _ in
            exit(1)
        })
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    enum AlertNamespace {
        static let confirm = "확인"
        static let jsonDecodingErrorTitle = "데이터 읽기 오류"
        static let jsonDecodingErrorMessage = "데이터를 읽을 수 없어 앱을 종료합니다."
    }
}
