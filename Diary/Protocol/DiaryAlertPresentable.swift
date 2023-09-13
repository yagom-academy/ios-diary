//
//  DiaryAlertPresentable.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/08.
//

import UIKit

protocol DiaryAlertPresentable where Self: UIViewController { }

extension DiaryAlertPresentable {
    var closeAction: UIAlertAction {
        let action = UIAlertAction(title: String(localized: "Close"), style: .cancel)
        
        return action
    }
    
    func presentDeleteConfirmAlert(by action: @escaping () -> Void) {
        let alert = UIAlertController(
            title: String(localized: "DeleteConfirmAlertTitle"),
            message: String(localized: "DeleteConfirmAlertMessage"),
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
        let deleteAction = UIAlertAction(title: String(localized: "Delete"), style: .destructive) { _ in
            action()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    func presentDiarySaveFailureAlert() {
        let alert = UIAlertController(
            title: nil,
            message: String(localized: "DiarySaveFailMessage"),
            preferredStyle: .alert
        )
        
        alert.addAction(closeAction)
        
        self.present(alert, animated: true)
    }
    
    func presentErrorCheckAlert(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(closeAction)
        
        self.present(alert, animated: true)
    }
}
