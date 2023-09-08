//
//  DiaryAlertPresentable.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/08.
//

import UIKit

protocol DiaryAlertPresentable { }

extension DiaryAlertPresentable {
    func showDeleteConfirmAlert(in viewController: UIViewController, by action: @escaping () -> Void) {
        let alert = UIAlertController(
            title: String(localized: "DeleteConfirmAlertTitle"),
            message: String(localized: "DeleteConfirmAlertMessage"),
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
        let deleteAction = UIAlertAction(title: String(localized: "delete"), style: .destructive) { _ in
            action()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        viewController.present(alert, animated: true)
    }
}
