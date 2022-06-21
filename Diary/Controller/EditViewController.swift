//
//  EditViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import UIKit

final class EditViewController: DiaryViewController {
    private var diary: Diary?
    
    init(diary: Diary?) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    private func setInitialView() {
        if let createdAt = diary?.createdAt {
            self.title = Date(timeIntervalSince1970: createdAt).dateToKoreanString
            configureDiaryView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: Notification.Name.sceneDidEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func saveDiary() {
        update(setTestData())
        delegate?.updateView()
    }
    
    private func setTestData() -> Diary? {
        var textArray = diaryText()
        guard let id = diary?.id else {
            return nil
        }
        return Diary(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: id)
    }
    
    private func configureDiaryView() {
        guard let diary = diary else {
            return
        }
        
        diaryView.configureContents(diary: diary)
    }
}
