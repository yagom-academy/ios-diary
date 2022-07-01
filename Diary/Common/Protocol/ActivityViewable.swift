//
//  ActivityViewable.swift
//  Diary
//
//  Created by 조민호 on 2022/07/01.
//

import UIKit

protocol ActivityViewable {}

extension ActivityViewable {
    func showActivityView(data: DiaryEntity, presentedViewController: UIViewController) {
        let textToShare: [Any] = [
            ShareActivityItemSource(
                title: data.title ?? AppConstants.noTitle,
                text: data.createdAt.formattedString)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        presentedViewController.present(activityViewController, animated: true)
    }
}
