//
//  AlertControllerManager.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import UIKit

struct AlertControllerManager {
    func createActionSheet(_ shareHandler: @escaping () -> Void,
                           _ deleteHandler: @escaping () -> Void) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            shareHandler()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            deleteHandler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
    
    func createDeleteAlert(_ deleteHandler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            deleteHandler()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        return alert
    }
}
