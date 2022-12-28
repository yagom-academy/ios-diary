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
                         useAction: Bool = false,
                         completion: (() -> Void)?) {
        let alert = UIAlertController(title: alertText,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        
        if useAction == true {
            let confirm = UIAlertAction(title: "취소", style: .destructive) {  _ in
                if let completion = completion {
                    completion()
                }
            }
            alert.addAction(confirm)
            self.present(alert, animated: true)
        } else {
            self.present(alert, animated: true)
            alert.dismiss(animated: true)
        }
    }
}
