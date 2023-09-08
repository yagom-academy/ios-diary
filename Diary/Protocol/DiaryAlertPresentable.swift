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
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            action()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        viewController.present(alert, animated: true)
    }
}
