//
//  UIViewController+Extension.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/26.
//

import UIKit

extension UIViewController {
    func showCustomAlert(alertText: String,
                         alertMessage: String,
                         bool: Bool,
                         completion: (() -> Void)?) {
        
        let alert = UIAlertController(title: alertText,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        
        if bool {
            self.present(alert, animated: true) {
                Thread.sleep(forTimeInterval: 0.5)
            }
            alert.dismiss(animated: true) {
                guard let completion = completion else { return }
                completion()
            }
        } else {
            let confirm = UIAlertAction(title: "취소", style: .destructive) {  _ in
                if let completion = completion {
                    completion()
                }
            }
            alert.addAction(confirm)
            self.present(alert, animated: true)
        }
        
    }
}
