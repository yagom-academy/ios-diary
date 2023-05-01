//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreData

final class DetailDiaryViewController: UIViewController {
    private var diaryDate: String?
    private var bottomConstraint: NSLayoutConstraint?
    private var coreDataManager = CoreDataManager.shared
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NameSpace.diaryPlaceholder
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
        addKeyboardNotification()
    }
    
    func configureContent(diary: Entity) {
        guard let title = diary.title,
              let body = diary.body else { return }
        
        diaryTextView.text = title + NameSpace.newline + body
        diaryTextView.contentOffset = CGPoint.zero
        diaryDate = Date(timeIntervalSince1970: diary.date).convertDate()
        self.title = diaryDate
    }
    
    private func createDiary() {
        guard let diary = configureDiary() else { return }
        
        coreDataManager.createDiary(diary)
    }
    
    private func configureDiary() -> Diary? {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        let title = String(diaryContents[0])
        let body = String(diaryContents[1])
        
        guard let date = Date().timeIntervalSince1970.roundDownNumber() else { return nil }
        
        return Diary(title: title, body: body, date: date)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        diaryTextView.setContentOffset(.zero, animated: true)
        let endDiaryButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(endEditTextView))
        navigationItem.rightBarButtonItem = endDiaryButton
        
        if diaryDate == nil {
            title = Date().convertDate()
        }
    }
    
    @objc
    private func endEditTextView() {
        self.diaryTextView.endEditing(true)
        createDiary()
        
    }
    
    private func configureSubview() {
        view.addSubview(diaryTextView)
    }
    
    private func configureConstraint() {
        bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let firstWindow = UIApplication.shared.windows.first {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let changedHeight = -(keyboardHeight - firstWindow.safeAreaInsets.bottom)
            bottomConstraint?.constant = changedHeight
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        bottomConstraint?.constant = 0
    }
}

private enum NameSpace {
    static let newline = "\n"
    static let diaryPlaceholder = "내용을 입력하세요"
}
