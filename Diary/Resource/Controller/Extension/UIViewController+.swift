//
//  UIViewController+.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/29.
//

import UIKit

extension UIViewController {
    func showDeleteAlert(for diaryModel: DiaryModel?, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert: UIAlertController = UIAlertController(title: Namespace.deleteDiary,
                                                         message: Namespace.deleteMessage,
                                                         preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: Namespace.cancel,
                                                        style: .cancel)
        let deleteAction: UIAlertAction = UIAlertAction(title: Namespace.delete,
                                                        style: .destructive,
                                                        handler: handler)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func showErrorAlert(title: String) {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: nil,
                                                         preferredStyle: .alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: Namespace.empty,
                                                         style: .default)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
}
