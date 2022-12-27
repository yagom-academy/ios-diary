//
//  AddDiaryView.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class AddDiaryView: DiaryView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textView.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchTextViewContent() -> String {
        return self.textView.text
    }
    
}
