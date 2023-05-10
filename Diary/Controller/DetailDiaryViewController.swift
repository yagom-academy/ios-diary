//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private var diaryDate: String?
    private var coreDataManager = CoreDataManager.shared
    private let isDiaryCreated: Bool
    private var isSaveRequired: Bool
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
    
    init(isCreateDiary: Bool, isSaveRequired: Bool) {
        self.isDiaryCreated = isCreateDiary
        self.isSaveRequired = isSaveRequired
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
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
        title = diaryDate
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
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showDetailAction))
        
        if diaryDate == nil {
            title = Date().convertDate()
        }
    }
    
    private func configureKeyboard() {
        if isDiaryCreated {
            diaryTextView.becomeFirstResponder()
        }
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
            self.saveDiary()
            guard let diary = self.diary else { return }
            ActionController.showActivityViewController(from: self,
                                                        title: diary.title,
                                                        body: diary.body)
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
    
    // MARK: - CoreData method
    private func saveDiary() {
        if isSaveRequired {
            if isDiaryCreated {
                createDiary()
            } else {
                updateDiary()
            }
            
            isSaveRequired = false
        }
    }
    
    private func createDiary() {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)

        guard diaryContents.count != 0,
              let date = Date().timeIntervalSince1970.roundDownNumber() else { return }
        
        let id = UUID()
        let title = String(diaryContents[0])
        let body = validBody(diaryContents)
        
        diary = Diary(id: id, title: title, body: body, date: date)
        
        guard let diaryForCoreData = diary else { return }
        
        coreDataManager.createDiary(diaryForCoreData)
    }
    
    private func updateDiary() {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        
        guard diaryContents.count != 0 else {
            deleteDiary()
            
            return
        }
        
        let title = String(diaryContents[0])
        let body = validBody(diaryContents)

        guard let id = diary?.id,
              let date = Date().timeIntervalSince1970.roundDownNumber() else { return }
        
        diary = Diary(id: id, title: title, body: body, date: date)
        
        guard let diaryForCoreData = diary else { return }
        
        coreDataManager.updateDiary(diary: diaryForCoreData)
    }

    private func deleteDiary() {
        guard let diary else { return }
        
        do {
            try self.coreDataManager.deleteDiary(diary: diary)
        } catch {
            let alert = UIAlertController(title: "알림", message: "\(error)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        isSaveRequired = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validBody(_ string: [String.SubSequence]) -> String {
        var result: String = NameSpace.empty
        
        if string.count == 2 {
            result = String(string[1])
        }
        
        return result
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
