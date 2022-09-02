//
//  UIViewController + extension.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/28.
//

import UIKit

extension UIViewController {
    func showErrorAlert(error: String) {
        let alertController = UIAlertController(
            title: "⚠️",
            message: error,
            preferredStyle: .alert
        )
        let okButton = UIAlertAction(
            title: "확인",
            style: .default,
            handler: nil
        )
        alertController.addAction(okButton)
        
        present(
            alertController,
            animated: true
        )
    }
    
    func showActivityView(diaryContent: DiaryContents?) {
        guard let content = diaryContent else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [content.title as Any],
            applicationActivities: nil
        )
        
        present(
            activityViewController,
            animated: true,
            completion: nil
        )
    }
}
