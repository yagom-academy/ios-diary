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
                                      message: "요청한 작업 실패 \n \(error.localizedDescription)",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showActivityView(_ text: String) {
        let activityView = UIActivityViewController(activityItems: [UIImage(systemName: "star.fill")!, text, "abc"], applicationActivities: nil)
        
        present(activityView, animated: true)
    }
}
