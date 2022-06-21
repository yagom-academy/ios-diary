//
//  AddViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import UIKit

final class AddViewController: DiaryViewController {
    let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        diaryView.diaryTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update(setTestData())
        delegate?.updateView()
    }
    
    private func setInitialView() {
        self.title = Date().dateToKoreanString
    }
    
    private func setTestData() -> Diary? {
        var textArray = diaryView.diaryTextView.text.components(separatedBy: "\n")
        return Diary(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: id)
    }
}
