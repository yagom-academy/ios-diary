//
//  UIActivityViewController+.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import UIKit

extension UIActivityViewController {
    convenience init(diaryItemManager: DiaryItemManager) {
        let diaryForm: String = diaryItemManager.createDiaryShareForm()
        
        self.init(activityItems: [diaryForm], applicationActivities: nil)
    }
}
