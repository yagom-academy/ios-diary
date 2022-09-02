//
//  AlertManager.swift
//  Diary
//
//  Created by 이원빈 on 2022/09/01.
//

import UIKit

struct AlertManager {
    
    private enum AlertMassage {
        static let shareActionTitle = "share..."
        static let deleteActionTitle = "Delete"
        static let cancel = "취소"
        static let deleteAlertTitle = "진짜요?"
        static let deleteAlertMessage = "정말로 삭제하시겠어요?"
        static let cancelActionTitle = "Cancel"
    }
    
    func showActionSheet(in viewController: DiaryViewController, with diary: Diary?) {
        guard let diary = diary else { return }
        let share = generateShareAlertAction(with: diary, in: viewController)
        let delete = generateDeleteAlertAction(in: viewController)
        let cancel = generateCancelAlertAction()
        showAlertController(title: nil,
                            message: nil,
                            style: .actionSheet,
                            actions: [share, cancel, delete]) { alertController in
            viewController.present(alertController, animated: true)
        }
    }
    
    private func showAlertController(title: String?,
                                     message: String?,
                                     style: UIAlertController.Style,
                                     actions: [UIAlertAction],
                                     _ completion: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { action in
            alertController.addAction(action)
        }
        completion(alertController)
    }
    
    // MARK: - ActionSheet Buttons
    
    private func generateShareAlertAction(with model: Diary, in viewController: DiaryViewController) -> UIAlertAction {
        let share = UIAlertAction(title: AlertMassage.shareActionTitle, style: .default) { _ in
            let diaryToShare: [MyActivityItemSource] = [MyActivityItemSource(title: model.title ?? "", text: model.body ?? "")]
            let activityViewController = UIActivityViewController(activityItems: diaryToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = viewController.diaryView
            viewController.present(activityViewController, animated: true)
        }
        return share
    }
    
    private func generateDeleteAlertAction(in viewController: DiaryViewController ) -> UIAlertAction {
        let deleteAction = UIAlertAction(title: AlertMassage.deleteActionTitle, style: .destructive) { _ in
            let cancel = cancel()
            let delete = delete {
                viewController.diaryView.diaryTextView.text = nil
                viewController.navigationController?.popViewController(animated: true)
            }
            showAlertController(title: AlertMassage.deleteAlertTitle, message: AlertMassage.deleteAlertMessage,
                                style: .alert, actions: [cancel, delete]) { alertController in
                viewController.present(alertController, animated: true)
            }
        }
        return deleteAction
    }
    
    private func generateCancelAlertAction() -> UIAlertAction {
        return UIAlertAction(title: AlertMassage.cancelActionTitle, style: .cancel)
    }
    
    // MARK: - Alert Buttons
    
    private func delete(_ completion: @escaping () -> Void) -> UIAlertAction {
        let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            completion()
        }
        return delete
    }
    
    private func cancel() -> UIAlertAction {
        return UIAlertAction(title: AlertMassage.cancel, style: .cancel)
    }
}
