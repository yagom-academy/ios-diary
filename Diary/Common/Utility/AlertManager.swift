//
//  AlertManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/26.
//

import UIKit

struct AlertManager {
    func showErrorAlert(target: UIViewController, error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        target.present(alert, animated: true)
    }
    
    func showDeleteAlert(target: UIViewController, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in handler() }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        target.present(alert, animated: true)
    }
}
