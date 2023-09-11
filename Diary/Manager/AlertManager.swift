//
//  AlertManager.swift
//  Diary
//
//  Created by 예찬 on 2023/09/11.
//

import UIKit

final class AlertManager: UIViewController {
    let uuid: UUID
    
    init(uuid: UUID) {
        self.uuid = uuid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func seeMoreButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteButtonTapped()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func deleteButtonTapped() {
        let deleteAlertController = UIAlertController(title: "Really??", message: "Think one more", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            CoreDataManager.shared.delete(diary: self.uuid)
            self.navigationController?.popViewController(animated: true)
        }
        
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        
        present(deleteAlertController, animated: true)
    }
    
    func showActivityView() {
        let activityViewController = UIActivityViewController(activityItems: ["타이틀 넣어야함"], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
