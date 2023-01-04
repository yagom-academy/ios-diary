//
//  AlertManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/29.
//

import UIKit

protocol AlertDelegate: AnyObject {
    func showErrorAlert(title: String)
}

final class AlertManager {
    func showDeleteAlert(handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: AlertMessage.deleteDiary,
                                                         message: AlertMessage.deleteMessage,
                                                         preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: Namespace.cancel,
                                                        style: .cancel)
        let deleteAction: UIAlertAction = UIAlertAction(title: Namespace.delete,
                                                        style: .destructive,
                                                        handler: handler)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        return alert
    }
    
    func showErrorAlert(title: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: nil,
                                                         preferredStyle: .alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: Namespace.empty,
                                                         style: .default)
        alert.addAction(confirmAction)
        return alert
    }
    
    private enum AlertMessage {
        static let deleteDiary = "일기 삭제"
        static let deleteMessage = "정말로 삭제하시겠습니까?"
    }
}
