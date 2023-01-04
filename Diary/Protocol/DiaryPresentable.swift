//
//  DiaryPresentable.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import UIKit

protocol DiaryPresentable {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension DiaryPresentable {
    func showActivityViewController(diary: Diary) {
        let textToShare: String = "\(diary.title)\n\(diary.body)"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
    }

    func showDeleteActionAlert(diary: Diary, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            CoreDataManager.shared.delete(diary: diary)
            if let completion = completion {
                completion()
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
}
