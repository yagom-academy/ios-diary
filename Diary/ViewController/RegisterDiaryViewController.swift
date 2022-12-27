//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 맹선아 on 2022/12/21.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    
    private let diaryDetailView: DiaryDetailView = DiaryDetailView()
    private var diaryCoreDataManager = CoreDataManager.shared
    private var diaryPage = DiaryPage(title: " ", body: " ", createdAt: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryDetailView
        diaryCoreDataManager.saveDiary(diaryPage)
        diaryDetailView.addTextViewsDelegate(self)
        setupNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateDiary()
    }
    
    @objc private func updateDiary() {
        diaryPage.title = diaryDetailView.title
        diaryPage.body = diaryDetailView.body
        
        diaryCoreDataManager.updateDiary(diaryPage)
    }
}

extension RegisterDiaryViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        diaryDetailView.removePlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        diaryDetailView.setupPlaceHolder()
    }
}

extension RegisterDiaryViewController {
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDiary),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc private func controlKeyboard(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue
                = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let bottomInset = self.diaryDetailView.scrollViewBottomInset
        let keyboardShowNotification = UIResponder.keyboardWillShowNotification
        let keyboardHideNotification = UIResponder.keyboardWillHideNotification
        
        if notification.name == keyboardShowNotification && bottomInset == 0 {
            self.diaryDetailView.changeScrollViewBottomInset(keyboardHeight)
        } else if notification.name == keyboardHideNotification && bottomInset != 0 {
            self.diaryDetailView.changeScrollViewBottomInset(-keyboardHeight)
            updateDiary()
        }
    }
}
