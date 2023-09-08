//
//  DiaryShareable.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/08.
//

import UIKit

protocol DiaryShareable {
    func shareDiary(data: DiaryEntity?, in viewController: UIViewController)
}

extension DiaryShareable {
    func shareDiary(data: DiaryEntity?, in viewController: UIViewController) {
        guard let data else {
            return
        }
        let diaryContent: [Any] = [DiaryActivityItemSource(diary: data)]
        let activityViewController = UIActivityViewController(
            activityItems: diaryContent,
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
