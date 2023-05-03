//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreData

final class DetailDiaryViewController: UIViewController {
    private var diaryDate: String?
    private var coreDataManager = CoreDataManager.shared
    private var isCreateDiary: Bool = false
    private var isSaveRequired: Bool = true
    private var diary: Diary?
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NameSpace.diaryPlaceholder
        textView.keyboardDismissMode = .interactive
        
        return textView
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        return button
    }()
    
    init(isCreateDiary: Bool, isSaveRequired: Bool) {
        self.isCreateDiary = isCreateDiary
        self.isSaveRequired = isSaveRequired
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
        configureKeyboard()
        addDeactiveNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    func configureContent(diary: Diary) {
        self.diary = diary
        diaryTextView.text = diary.title + NameSpace.newline + diary.body
        diaryTextView.contentOffset = CGPoint.zero
        diaryDate = Date(timeIntervalSince1970: diary.date).convertDate()
        self.title = diaryDate
    }
    
    // MARK: - configure method
    private func configureSubview() {
        view.addSubview(diaryTextView)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        diaryTextView.delegate = self
        diaryTextView.setContentOffset(.zero, animated: true)
        
        detailButton.addTarget(self, action: #selector(showDetailAction), for: .touchUpInside)
        let detailDiaryButton = UIBarButtonItem(customView: detailButton)
        navigationItem.rightBarButtonItem = detailDiaryButton
        
        if diaryDate == nil {
            title = Date().convertDate()
        }
    }
    
    private func configureKeyboard() {
        if isCreateDiary {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    private func configureDiary() -> Diary? {
        let id = UUID()
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        let title = String(diaryContents[0])
        var body: String
        
        if diaryContents.count == 2 {
            body = String(diaryContents[1])
        } else {
            body = NameSpace.empty
        }
        
        guard let date = Date().timeIntervalSince1970.roundDownNumber() else { return nil }
        
        return Diary(id: id, title: title, body: body, date: date)
    }
    
    // MARK: - Notification method
    private func addDeactiveNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterTaskSwitcher),
                                               name: UIScene.willDeactivateNotification,
                                               object: nil)
    }
    
    @objc
    private func enterTaskSwitcher() {
        saveDiary()
    }
    
    // MARK: - Action Sheet method
    @objc
    private func showDetailAction() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let share = UIAlertAction(title: NameSpace.share, style: .default) { _ in
            ActionController.showActivityViewController(from: self)
        }
        
        let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            self.showDeleteAlert()
        }
        
        let cancel = UIAlertAction(title: NameSpace.cancel, style: .cancel)
        
        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
    
    // MARK: - CoreData method
    private func saveDiary() {
        if isSaveRequired {
            if isCreateDiary {
                createDiary()
            } else {
                updateDiary()
            }
            
            isSaveRequired = false
        }
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
        
        let updatedDiary = Diary(id: id, title: title, body: body, date: date)
        
        coreDataManager.updateDiary(diary: updatedDiary)
    }

    private func deleteDiary() {
        guard let diary else { return }
        
        coreDataManager.deleteDiary(diary: diary)
        isSaveRequired = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: NameSpace.alertTitle,
                                      message: NameSpace.alertMessage,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: NameSpace.cancel, style: .cancel)
        let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            self.deleteDiary()
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
}

private enum NameSpace {
    static let diaryPlaceholder = "내용을 입력하세요"
    static let newline = "\n"
    static let empty = ""
    static let share = "공유"
    static let cancel = "취소"
    static let delete = "삭제"
    static let alertTitle = "진짜요?"
    static let alertMessage = "정말로 삭제하시겠어요?"
}
