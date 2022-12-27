//
//  EditDiaryView.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/27.
//

import UIKit

final class EditDiaryView: DiaryView {
    func configureView(with diaryData: DiaryModel) {
        self.textView.text = diaryData.title + diaryData.body
    }
}
