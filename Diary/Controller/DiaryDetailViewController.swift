//
//  DiaryDetailViewController.swift
//  Diary
//
// Created by SeHong on 2023/04/24.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    private enum ButtonConstant {
        static let shareActionTitle = "공유"
        static let cancelActionTitle = "취소"
        static let deleteActionTitle = "삭제"
        static let deleteAlertTitle = "진짜요?"
        static let deleteAlertMessage = "정말로 삭제 하시겠어요?"
    }
    
    private let coreDataManager: CoreDataManager
    
    private var diary: Diary?
    
    private var titleText: String = ""
    private var bodyText: String = ""
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.endEditing(true)
        return textView
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.endEditing(true)
        return textView
    }()
    
    init(coreDataManager: CoreDataManager = .shared, diary: Diary? = nil) {
        self.coreDataManager = coreDataManager
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupLayout()
        configureView()
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFirstResponder()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil {
            saveOrUpdateDiary()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain,
                        target: self, action: #selector(detailButtonTapped))
    }
    
    @objc func appDidEnterBackground() {
        saveOrUpdateDiary()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        saveOrUpdateDiary()
    }
    
    @objc
    private func detailButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: ButtonConstant.shareActionTitle, style: .default) { [weak self] _ in
            guard let self else { return }
            self.shareButtonTapped()
        }
        
        let deleteAction = UIAlertAction(title: ButtonConstant.deleteActionTitle, style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.createDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: ButtonConstant.cancelActionTitle, style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach(actionSheet.addAction)
        
        present(actionSheet, animated: true)
    }
    
    func saveOrUpdateDiary() {
        guard !titleText.isEmpty || !bodyText.isEmpty else { return }
        
        if let diary {
            diary.title = titleText
            diary.body = bodyText
            let result = coreDataManager.updateDiaryData(newDiaryData: diary)
            switch result {
            case .success:
                print("업데이트 성공")
                NotificationCenter.default.post(name: .coreDataChanged, object: nil)
                
            case .failure(let error):
                let errorTitle = "업데이트 실패"
                let errorMessage = error.userErrorMessage
                showAlertWithMessage(errorTitle, errorMessage)
            }
        } else {
            let result = coreDataManager.saveDiaryData(titleText: titleText, bodyText: bodyText)
            switch result {
            case .success(let diary):
                self.diary = diary
                print("저장 성공")
                NotificationCenter.default.post(name: .coreDataChanged, object: nil)
            case .failure(let error):
                let errorTitle = "저장 실패"
                let errorMessage = error.userErrorMessage
                showAlertWithMessage(errorTitle, errorMessage)
            }
        }
    }
    
    private func shareButtonTapped() {
        share(someText: diary?.title)
    }
    
    private func deleteDiary() {
        guard let diaryData = diary else { return }
        let result = coreDataManager.deleteDiaryData(data: diaryData)
        switch result {
        case .success:
            print("삭제 성공")
            diary = nil
            NotificationCenter.default.post(name: .coreDataChanged, object: nil)
        case .failure(let error):
            let errorTitle = "삭제 실패"
            let errorMessage = error.userErrorMessage
            showAlertWithMessage(errorTitle, errorMessage)
        }
    }
    
    func createDeleteAlert() {
        let alert = UIAlertController(
            title: ButtonConstant.deleteAlertTitle,
            message: ButtonConstant.deleteAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: ButtonConstant.cancelActionTitle,
            style: .default,
            handler: nil
        )
        let deleteAction = UIAlertAction(
            title: ButtonConstant.deleteActionTitle,
            style: .destructive
        ) { [weak self] _ in
            guard let self else { return }
            self.deleteDiary()
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertWithMessage(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextView)
        view.addSubview(bodyTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }
    
    private func configureView() {
        setData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func setData() {
        if let diary {
            title = DateToStringFormatter.changeToString(from: diary.createdAt)
            titleTextView.text = diary.title
            bodyTextView.text = diary.body
        }
    }
    
    private func setFirstResponder() {
        if diary == nil {
            titleTextView.becomeFirstResponder()
        }
    }
    
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            titleText = textView.text
        } else if textView == bodyTextView {
            bodyText = textView.text
        }
    }
}
