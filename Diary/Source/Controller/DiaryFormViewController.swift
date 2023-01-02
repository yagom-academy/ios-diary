//
//  DiaryFormViewController.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import CoreData
import UIKit

final class DiaryFormViewController: UIViewController {
    // MARK: Properties
    
    private let diaryFormView = DiaryFormView()
    private var selectedDiary: Diary?
    private let alertControllerManager = AlertControllerManager()
    private let activityControllerManager = ActivityControllerManager()
    
    // MARK: Initializer
    
    init(diary: Diary? = nil) {
        selectedDiary = diary
        
        if let diary = diary {
            diaryFormView.diaryTextView.text = diary.totalText
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureDiaryViewLayout()
        configureNavigationBar()
        setUpNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        diaryFormView.diaryTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectSaveOrUpdate()
    }
    
    // MARK: Internal Methods
    
    func selectSaveOrUpdate() {
        let diary = createDiary()
        
        if selectedDiary != nil {
            update(diary: diary)
        } else {
            if !diary.totalText.isEmpty {
                selectedDiary = diary
                save(diary: diary)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func configureDiaryViewLayout() {
        view.addSubview(diaryFormView)
        
        NSLayoutConstraint.activate([
            diaryFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = DateFormatter.koreanDateFormatter.string(from: Date())
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: NameSpace.rightBarButtonImage),
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func createDiary() -> Diary {
        var uuid = UUID()
        var title = diaryFormView.diaryTitle
        let body = diaryFormView.diaryBody
        
        if let id = selectedDiary?.id {
            uuid = id
        }
        
        if title.isEmpty {
            title = NameSpace.emptyTitle
        }
        
        let diary = Diary(
            title: title,
            body: body,
            createdAt: Int(Date().timeIntervalSince1970),
            totalText: diaryFormView.diaryTextView.text,
            id: uuid
        )

        return diary
    }
    
    private func showDeleteAlert() {
        guard let diary = selectedDiary else { return }
        
        present(
            alertControllerManager.createDeleteAlert({
                self.delete(diary: diary)
                self.navigationController?.popViewController(animated: true)
            }),
            animated: true
        )
    }
    
    private func showActivityController() {
        if let totalText = diaryFormView.diaryTextView.text, !totalText.isEmpty {
            present(
                activityControllerManager.showActivity(textToShare: totalText),
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: Action Methods
    
    @objc private func showActionSheet() {
        present(
            alertControllerManager.createActionSheet(showActivityController, showDeleteAlert),
            animated: true,
            completion: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let textView = diaryFormView.diaryTextView
        
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: keyboardFrame.size.height,
                right: 0.0
            )
            
            textView.contentInset = contentInset
            textView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let textView = diaryFormView.diaryTextView
        
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
        
        selectSaveOrUpdate()
    }
}

// MARK: - CoreDataProcessable

extension DiaryFormViewController: CoreDataProcessable {
    func save(diary: Diary) {
        let result = saveCoreData(diary: diary)
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            present(
                alertControllerManager.createErrorAlert(error),
                animated: true
            )
        }
    }
    
    func update(diary: Diary) {
        let result = updateCoreData(diary: diary)
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            present(
                alertControllerManager.createErrorAlert(error),
                animated: true
            )
        }
    }
    
    func delete(diary: Diary) {
        let result = deleteCoreData(diary: diary)
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            present(
                alertControllerManager.createErrorAlert(error),
                animated: true
            )
        }
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let rightBarButtonImage = "ellipsis.circle"
    static let emptyTitle = "[제목없음]"
}
