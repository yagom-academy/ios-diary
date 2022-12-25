//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diaryDetailView: DiaryDetailView
    private var diary: Diary?
    
    init(diary: Diary) {
        self.diary = diary
        self.diaryDetailView = DiaryDetailView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryDetailView
        configureDiary()
        setupNavigationBar()
        setupNotification()
    }
    
    private func configureDiary() {
        guard let diary = diary else {
            return
        }
        
        diaryDetailView.configureTextView(title: diary.title, body: diary.body)
    }
}

extension DiaryDetailViewController {
    
    private func setupNavigationBar() {
        self.navigationItem.title = diary?.createdDate
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
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
        }
    }
}
