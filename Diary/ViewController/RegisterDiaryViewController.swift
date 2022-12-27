//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 맹선아 on 2022/12/21.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    
    private let diaryPageView: DiaryDetailView = DiaryDetailView()
    private var diaryPage = DiaryPage(title: " ", body: " ", createdAt: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryPageView
        CoreDataManager.shared.saveDiary(diaryPage)
        diaryPageView.addTextViewsDelegate(self)
        setupNotification()
        diaryPageView.makeTitleTextViewFirstResponder()
        diaryPageView.setupPlaceHolder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateDiary()
    }
    
    @objc func updateDiary() {
        diaryPage.title = diaryPageView.title
        diaryPage.body = diaryPageView.body
        
        CoreDataManager.shared.updateDiary(diaryPage)
    }
}

extension RegisterDiaryViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        diaryPageView.removePlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        diaryPageView.setupPlaceHolder()
    }
}

extension RegisterDiaryViewController {
    
    func setupNotification() {
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
    
    @objc func controlKeyboard(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue
                = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let bottomInset = self.diaryPageView.scrollViewBottomInset
        let keyboardShowNotification = UIResponder.keyboardWillShowNotification
        let keyboardHideNotification = UIResponder.keyboardWillHideNotification
        
        if notification.name == keyboardShowNotification && bottomInset == 0 {
            self.diaryPageView.changeScrollViewBottomInset(keyboardHeight)
        } else if notification.name == keyboardHideNotification && bottomInset != 0 {
            self.diaryPageView.changeScrollViewBottomInset(-keyboardHeight)
            updateDiary()
        }
    }
}
