//
//  DiaryShareable.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/08.
//

import UIKit

protocol DiaryShareable where Self: UIViewController { }

extension DiaryShareable {
    func shareDiary(data: DiaryEntity?) {
        guard let data else {
            return
        }
        
        let diaryContent: [Any] = [DiaryActivityItemSource(diary: data)]
        let activityViewController = UIActivityViewController(
            activityItems: diaryContent,
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
