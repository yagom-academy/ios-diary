//
//  AddViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import UIKit

final class AddViewController: DiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        diaryView.diaryTextView.becomeFirstResponder()
    }
    
    private func setInitialView() {
        self.title = Date().dateToKoreanString
    }
}
