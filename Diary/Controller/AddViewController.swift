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
        saveDiary()
    }
    
    private func setInitialView() {
        self.title = Date().dateToKoreanString
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: Notification.Name.sceneDidEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func saveDiary() {
        update(setTestData())
        delegate?.updateView()
    }
    
    private func setTestData() -> Diary? {
        var textArray = diaryText()
        return Diary(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: id)
    }
}
