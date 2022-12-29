//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    
    private let diaryPageView: DiaryDetailView
    private var diaryPage: DiaryPage

    init(diaryPageView: DiaryDetailView = DiaryDetailView(), diary: DiaryPage) {
        self.diaryPageView = diaryPageView
        self.diaryPage = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryPageView
        CoreDataManager.shared.save(diaryPage)
        diaryPageView.addTextViewsDelegate(self)
        setupNavigationBar()
        setupNotification()
        diaryPageView.makeTitleTextViewFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        diaryPageView.setupPlaceHolder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateDiary()
    }
    
    @objc private func updateDiary() {
        diaryPage.title = diaryPageView.title
        diaryPage.body = diaryPageView.body
        CoreDataManager.shared.update(diaryPage)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = diaryPage.createdDate
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

extension RegisterDiaryViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        diaryPageView.removePlaceHolder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        diaryPageView.setupPlaceHolder()
    }
}
