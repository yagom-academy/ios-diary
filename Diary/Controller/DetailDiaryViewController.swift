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
    private var isCreateDiary: Bool = false
    private var diary: Diary?
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NameSpace.diaryPlaceholder
        
        return textView
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        return button
    }()
    
    init(isCreateDiary: Bool) {
        self.isCreateDiary = isCreateDiary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
        addKeyboardNotification()
        configureKeyboard()
    }
    
    func configureContent(diary: Diary) {
        self.diary = diary
        diaryTextView.text = diary.title + NameSpace.newline + diary.body
        diaryTextView.contentOffset = CGPoint.zero
        diaryDate = Date(timeIntervalSince1970: diary.date).convertDate()
        self.title = diaryDate
    }
    
    private func createDiary() {
        guard let diary = configureDiary() else { return }
        
        coreDataManager.createDiary(diary)
    }
    
    private func updateDiary() {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        let title = String(diaryContents[0])
        let body = String(diaryContents[1])
        
        guard let id = diary?.id,
              let date = Date().timeIntervalSince1970.roundDownNumber() else { return }
        
        let updatedDiary = Diary(title: title, body: body, date: date, id: id)
        
        coreDataManager.updateDiary(diary: updatedDiary)
    }
    
    private func configureDiary() -> Diary? {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        let title = String(diaryContents[0])
        let body = String(diaryContents[1])
        let id = UUID()
        
        guard let date = Date().timeIntervalSince1970.roundDownNumber() else { return nil }
        
        return Diary(title: title, body: body, date: date, id: id)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        diaryTextView.setContentOffset(.zero, animated: true)
        detailButton.addTarget(self, action: #selector(showDetailAction), for: .touchUpInside)
        let detailDiaryButon = UIBarButtonItem(customView: detailButton)
        navigationItem.rightBarButtonItem = detailDiaryButon
        
        if diaryDate == nil {
            title = Date().convertDate()
        }
    }
    
    @objc
    private func showDetailAction() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let save = UIAlertAction(title: "저장", style: .default) { _ in
            self.diaryTextView.endEditing(true)
            if self.isCreateDiary {
                self.createDiary()
            } else {
                self.updateDiary()
            }
        }
        
        let share = UIAlertAction(title: "공유", style: .default) { _ in
            
        }
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        actionSheet.addAction(save)
        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
    
    private func configureKeyboard() {
        if isCreateDiary {
            diaryTextView.becomeFirstResponder()
        }
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
