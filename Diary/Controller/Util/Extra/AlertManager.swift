//
//  AlertManager.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/04.
//

import UIKit

final class AlertManager {
    private enum LocalizationKey {
        static let mainTitle = "mainTitle"
        static let deleteAlertTitle = "deleteAlertTitle"
        static let deleteAlertMessage = "deleteAlertMessage"
        static let delete = "delete"
        static let cancel = "cancel"
        static let share = "share"
    }
    
    static func presentActivityView(diary: Diary?, at viewController: UIViewController?) {
        guard let validDiary = diary else { return }
        let activityViewController = UIActivityViewController(activityItems: [validDiary.sharedText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController?.view
        
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    static func presentDeleteAlert(diary: Diary?, at viewController: UIViewController?, completion: @escaping (Bool) -> Void ) {
        guard let validDiary = diary else {
            completion(false)
            return
        }
        
        let deleteAlert = UIAlertController(
            title: String.localized(key: LocalizationKey.deleteAlertTitle),
            message: String.localized(key: LocalizationKey.deleteAlertMessage),
            preferredStyle: .alert
        )
      
        let cancelAction = UIAlertAction(title: String.localized(key: LocalizationKey.cancel), style: .cancel)
        
        let deleteAction = UIAlertAction(title: String.localized(key: LocalizationKey.delete), style: .destructive) { _ in
            
            CoreDataManager.shared.delete(id: validDiary.id)
            completion(true)
        }
          
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        
        viewController?.present(deleteAlert, animated: true)
    }
}
