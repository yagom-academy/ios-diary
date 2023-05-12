//
//  DiaryAlertMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct DiaryAlertMaker: DiaryAlertFactory {
    func deleteDiaryAlert(for data: AlertViewData) -> UIAlertController {
        let alertController = UIAlertController(title: data.title,
                                                message: data.message,
                                                preferredStyle: data.style)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            data.completion()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func actionSheet(for data: ActionSheetViewData) -> UIAlertController {
        let alertController = UIAlertController(title: data.title,
                                                message: data.message,
                                                preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            data.shareCompletion()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            data.deleteCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func retryAlert(for data: AlertViewData) -> UIAlertController {
        let alertController = UIAlertController(title: data.title,
                                                message: data.message,
                                                preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "재시도", style: .default) { _ in
            data.completion()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
