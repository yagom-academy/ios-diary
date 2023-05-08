//
//  UIViewController+extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/04.
//

import UIKit

extension UIViewController {
    enum LocalizationKey {
        static let mainTitle = "mainTitle"
        static let deleteAlertTitle = "deleteAlertTitle"
        static let deleteAlertMessage = "deleteAlertMessage"
        static let delete = "delete"
        static let cancel = "cancel"
        static let share = "share"
    }
    
    func presentActivityView(diary: Diary?) {
        guard let validDiary = diary else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [validDiary.sharedText],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func presentDeleteAlert(diary: Diary?, completion: @escaping (Bool) -> Void ) {
        guard let validDiary = diary else {
            completion(false)
            return
        }
        
        let deleteAlert = UIAlertController(
            title: LocalizationKey.deleteAlertTitle.localized(),
            message: LocalizationKey.deleteAlertMessage.localized(),
            preferredStyle: .alert
        )
      
        let cancelAction = UIAlertAction(title: LocalizationKey.cancel.localized(), style: .cancel)
        
        let deleteAction = UIAlertAction(title: LocalizationKey.delete.localized(), style: .destructive) { _ in
            
            CoreDataManager.shared.delete(id: validDiary.id)
            completion(true)
        }
          
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        
        self.present(deleteAlert, animated: true)
    }
}
