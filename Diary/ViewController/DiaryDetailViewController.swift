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
        setupNavigationBar()
        configureDiary()
        setupNotification()
    }
    
    func configureDiary() {
        guard let diary = diary else {
            return
        }
        
        diaryDetailView.titleTextView.text = diary.title
        diaryDetailView.bodyTextView.text = diary.body
    }
}

extension DiaryDetailViewController {
    private func setupNavigationBar() {
        self.navigationItem.title = diary?.createdDate
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func controlKeyboard(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue
                = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        UIView.animate(withDuration: 0.5) {
            if notification.name == UIResponder.keyboardWillShowNotification {
                self.diaryDetailView.diaryTextScrollView.contentOffset.y += keyboardHeight
                self.diaryDetailView.diaryTextScrollView.contentInset.bottom += keyboardHeight
            } else if notification.name == UIResponder.keyboardWillHideNotification {
                self.diaryDetailView.diaryTextScrollView.contentInset.bottom -= keyboardHeight
            }
        }
    }
}
