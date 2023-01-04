//
//  EditDiaryView.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/27.
//

import UIKit

final class EditDiaryView: DiaryView {
    func configureView(with diaryData: DiaryModel) {
        let contents = diaryData.title + diaryData.body
        
        if contents.count == 0 {
            self.textView.text = ""
            self.textView.becomeFirstResponder()
        } else {
            self.textView.text = diaryData.title + "\n" + diaryData.body
            self.textView.contentOffset.y = 0
        }
    }
    
    func fetchTextViewContent() -> String {
        return self.textView.text
    }
}
