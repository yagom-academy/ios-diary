//
//  UIViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/21.
//

import UIKit

extension UIViewController {
    var alertController: UIAlertController {
        return UIAlertController()
    }
    
    func showActivityView(data: DiaryEntity) {
        let textToShare: [Any] = [
            ShareActivityItemSource(
                title: data.title ?? AppConstants.noTitle,
                text: data.createdAt.formattedString)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
