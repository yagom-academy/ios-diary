//
//  DiaryWriteViewController.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

final class DiaryDetailViewController: UIViewController {
    enum Constant {
        static let rightBarButtonName = "ellipsis"
    }
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "제목을 입력해주세요."
        titleTextField.font = UIFont.boldTitle1
        titleTextField.adjustsFontForContentSizeCategory = true
        
        return titleTextField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    
    private let coreDataManager = CoreDataManager.shared
    
    private var item: Diary? {
        didSet {
            self.titleTextField.text = item?.title
            self.contentTextView.text = item?.body
        }
    }
    
    private var isNotEmpty: Bool = false {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = isNotEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        contentTextView.delegate = self
        setNavigationBar()
        configureLayout()
        bindKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        updateAndCreateData()
    }
}

// MARK: Business Logic
extension DiaryDetailViewController {
    private func bindKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willShowKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willHideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func setDiary(with item: Diary? = nil) {
        self.item = item
        isNotEmpty = item != nil
    }
    
    private func createWithCoreData() {
        item = Diary(
            title: titleTextField.text,
            body: contentTextView.text,
            createdIntervalValue: 0,
            uuid: UUID()
        )
        coreDataManager.createDiary(diary: item)
        return
    }
    
    private func updateWithCoreData() {
        guard var item = item else { return }
        
        item.title = titleTextField.text
        item.body = contentTextView.text
        coreDataManager.updateDiary(diary: item)
    }
    
    func updateAndCreateData() {
        guard let title = titleTextField.text,
              let body = contentTextView.text,
              title.isNotEmpty || body.isNotEmpty else { return }
        
        if item == nil {
            createWithCoreData()
        } else {
            updateWithCoreData()
        }
    }
}

// MARK: Objc Method
extension DiaryDetailViewController {
    @objc private func willShowKeyboard(notification: Notification) {
        if contentTextView.isFirstResponder,
           let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           contentTextView.textContainerInset.bottom == 0 {
            contentTextView.contentInset.bottom = keyboardFrame.cgRectValue.height
        }
    }
    
    @objc private func willHideKeyboard(notification: Notification) {
        contentTextView.contentInset.bottom = 0
    }
}

// MARK: UITextField Delegate
extension DiaryDetailViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let title = textField.text,
              let body = contentTextView.text else { return true }
        
        isNotEmpty = title.isNotEmpty && body.isNotEmpty
        
        return true
    }
}

// MARK: UITextView Delegate
extension DiaryDetailViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        guard let title = titleTextField.text,
              let body = textView.text else { return true }
        
        isNotEmpty = title.isNotEmpty && body.isNotEmpty
        
        return true
    }
}

// MARK: UI Configuration
extension DiaryDetailViewController {
    private func addElementViews() {
        [titleTextField, contentTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        addElementViews()
        setTitleTextFieldAnchor()
        setContentTextViewAnchor()
    }
    
    private func setTitleTextFieldAnchor() {
        let safeArea = view.safeAreaLayoutGuide
        
        titleTextField.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            trailing: safeArea.trailingAnchor,
            paddingTop: 8,
            paddingLeading: 16,
            paddingTrailing: 16
        )
    }
    
    private func setContentTextViewAnchor() {
        let safeArea = view.safeAreaLayoutGuide
        
        contentTextView.anchor(
            top: titleTextField.bottomAnchor,
            leading: view.readableContentGuide.leadingAnchor,
            bottom: safeArea.bottomAnchor,
            trailing: view.readableContentGuide.trailingAnchor,
            paddingTop: 8
        )
    }
    
    private func setNavigationBar() {
        let currentDate = Date().convertString()
        navigationItem.setNavigationTitle(title: currentDate)
        
        let presentAction = UIAction(handler: presentActionSheet)
        navigationItem.setRightButton(
            systemName: Constant.rightBarButtonName,
            action: presentAction
        )
        navigationItem.rightBarButtonItem?.isEnabled = isNotEmpty
    }
    
    private func presentActionSheet(_ action: UIAction) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(type: .share, handler: shareHandler(_:))
        let deleteAction = UIAlertAction(type: .delete, handler: deleteHandler(_:))
        let cancelAction = UIAlertAction(type: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            alert.addAction($0)
        }
        
        self.present(alert, animated: true)
    }
    
    private func deleteHandler(_ action: UIAlertAction) {
        guard let item = item else { return }
        let alert = UIAlertController(
            title: "정말요?",
            message: "정말 삭제하실거에요?",
            diary: item,
            deleteCompletion: { _ in
                self.coreDataManager.deleteDiary(id: item.id)
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        present(alert, animated: true)
    }
    
    private func shareHandler(_ action: UIAlertAction) {
        guard let item = item else {
            return
        }
        
        let activityView = UIActivityViewController(
            activityItems: [item.content],
            applicationActivities: nil
        )
        
        self.present(activityView, animated: true)
    }
}

// MARK: String+
private extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
