//
//  AlertManager.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/04.
//

import UIKit

struct AlertManager {
    func showAlert(target: UIViewController,
                   completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion()
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        target.present(alert, animated: true)
    }
    
    func showActionSheet(target: UIViewController,
                         deleteCompletion: @escaping () -> Void,
                         shareCompletion: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "공유", style: .default) { _ in
            shareCompletion()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            deleteCompletion()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        target.present(actionSheet, animated: true)
    }
}
