//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    
    private let diaryDetailView: DiaryDetailView
    private var diaryInfo: DiaryInfo

    init(diaryDetailView: DiaryDetailView = DiaryDetailView(), diaryInfo: DiaryInfo) {
        self.diaryDetailView = diaryDetailView
        self.diaryInfo = diaryInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryDetailView
        CoreDataManager.shared.save(diaryInfo)
        diaryDetailView.addTextViewsDelegate(self)
        setupNavigationBar()
        setupNotification()
        diaryDetailView.makeTitleTextViewFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        diaryDetailView.setupPlaceHolder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateDiary()
    }
    
    @objc private func updateDiary() {
        diaryInfo.title = diaryDetailView.title
        diaryInfo.body = diaryDetailView.body
        CoreDataManager.shared.update(diaryInfo)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = diaryInfo.createdDate
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
        
        self.diaryDetailView.changeScrollViewBottomInset(keyboardHeight)
    }
}

extension RegisterDiaryViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        diaryDetailView.removePlaceHolder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        diaryDetailView.setupPlaceHolder()
    }
}
