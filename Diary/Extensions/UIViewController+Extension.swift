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
        
        if useAction {
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

extension UIViewController {
    func moveToActivityView(data: CurrentDiary?) {
        guard let sendingText = data?.contentText else { return }
        
        let activiyController = UIActivityViewController(activityItems: [sendingText],
                                                         applicationActivities: nil)
        activiyController.excludedActivityTypes = [.addToReadingList,
                                                   .assignToContact,
                                                   .openInIBooks,
                                                   .saveToCameraRoll]
        
        self.present(activiyController, animated: true, completion: nil)
    }
}
