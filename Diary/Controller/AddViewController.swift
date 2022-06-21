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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update(setTestData())
        delegate?.updateView()
    }
    
    private func setInitialView() {
        self.title = Date().dateToKoreanString
    }
    
    private func setTestData() -> TestData? {
        var textArray = diaryView.diaryTextView.text.components(separatedBy: "\n")
        return TestData(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: id)
    }
}
