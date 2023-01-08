//
//  AlertPresentable.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import UIKit

protocol AlertPresentable: UIViewController {
    func presentActionSheet(_ shareHandler: @escaping () -> Void,
                            _ deleteHandler: @escaping () -> Void)
    func presentDeleteAlert(_ deleteHandler: @escaping () -> Void)
    func presentErrorAlert(_ error: Error)
}

extension AlertPresentable {
    func presentActionSheet(_ shareHandler: @escaping () -> Void,
                            _ deleteHandler: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: NameSpace.shareTitle, style: .default) { _ in
            shareHandler()
        }
        let deleteAction = UIAlertAction(title: NameSpace.deleteTitle, style: .destructive) { _ in
            deleteHandler()
        }
        let cancelAction = UIAlertAction(title: NameSpace.cancelTitle, style: .cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func presentDeleteAlert(_ deleteHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: NameSpace.alertTitle,
            message: NameSpace.alertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: NameSpace.cancelKoreanTitle,
            style: .default,
            handler: nil
        )
        let deleteAction = UIAlertAction(
            title: NameSpace.deleteKoreanTitle,
            style: .destructive
        ) { _ in
            deleteHandler()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: nil,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: NameSpace.okTitle,
            style: .default
        )
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

private enum NameSpace {
    static let shareTitle = "Share"
    static let deleteTitle = "Delete"
    static let cancelTitle = "Cancel"
    static let okTitle = "확인"
    
    static let alertTitle = "진짜요?"
    static let alertMessage = "정말로 삭제하시겠어요?"
    static let cancelKoreanTitle = "취소"
    static let deleteKoreanTitle = "삭제"
}
