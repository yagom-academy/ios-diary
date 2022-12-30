//
//  DiaryWriteViewController.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let titleTextField = UITextField(
        font: UIFont.boldTitle1,
        placeholder: LocalizedConstant.TextField.titlePlaceholder
    )
    
    private let contentTextView = UITextView(
        font: .preferredFont(forTextStyle: .body),
        lineFragmentPadding: .zero,
        textContainerInset: .zero
    )
    
    private let coreDataManager = CoreDataManager.shared
    private var item: Diary?
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
    
    private func createWithCoreData() {
        createContents()
        coreDataManager.createDiary(diary: item)
        return
    }
    
    private func updateWithCoreData() {
        updateContents()
        coreDataManager.updateDiary(diary: item)
    }
    
    private func createContents(
        id: UUID = UUID(),
        timeInterval: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.item = Diary(
            id: id,
            title: titleTextField.filteredText,
            body: contentTextView.filteredText,
            timeInterval: Date().timeIntervalSince1970
        )
    }
    
    private func updateContents() {
        guard let createdDate = item?.createdDate,
              let id = item?.id else {
            return
        }
        
        let createdInterval = createdDate.timeIntervalSince1970
        if createdInterval.isToday() {
            createContents(id: id)
        }
        
        createContents(id: id, timeInterval: createdInterval)
    }
    
    private func checkButtonEnable() {
        let title = titleTextField.filteredText
        let body = contentTextView.filteredText
        
        isNotEmpty = title.isNotEmpty && body.isNotEmpty
    }
    
    func updateAndCreateData() {
        guard isNotEmpty else { return }
        
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
        updateAndCreateData()
    }
}

// MARK: UITextField, UITextView Delegate
extension DiaryDetailViewController: UITextFieldDelegate, UITextViewDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        checkButtonEnable()
        return true
    }
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        checkButtonEnable()
        return true
    }
}

// MARK: UI Configuration
extension DiaryDetailViewController {
    private func addElementViews() {
        [
            titleTextField,
            contentTextView
        ].forEach {
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
        let presentAction = UIAction(handler: presentActionSheet)
        navigationItem.setRightButton(systemImage: Constant.Images.moreImage, action: presentAction)
        navigationItem.rightBarButtonItem?.isEnabled = isNotEmpty
        
        var currentDate = Date().convertString()
        
        if let diaryDate = item?.createdDate.convertString() {
            currentDate = diaryDate
        }
        
        navigationItem.setNavigationTitle(title: currentDate)
    }
    
    private func presentActionSheet(_ action: UIAction) {
        view.endEditing(true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(type: .share, handler: didTappedShareButton(_:))
        let deleteAction = UIAlertAction(type: .delete, handler: didTappedDeleteButton(_:))
        let cancelAction = UIAlertAction(type: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            alert.addAction($0)
        }
        
        self.present(alert, animated: true)
    }
    
    private func didTappedDeleteButton(_ action: UIAlertAction) {
        guard let item = item else { return }
        let alert = UIAlertController(
            title: LocalizedConstant.AlertController.deleteTitle,
            message: LocalizedConstant.AlertController.deleteMessage,
            diary: item,
            deleteCompletion: { _ in
                self.coreDataManager.deleteDiary(id: item.id)
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        present(alert, animated: true)
    }
    
    private func didTappedShareButton(_ action: UIAlertAction) {
        guard let item = item else {
            return
        }
        
        let activityView = UIActivityViewController(
            activityItems: [item.convertShareContent()],
            applicationActivities: nil
        )
        
        self.present(activityView, animated: true)
    }
    
    func setDiary(with item: Diary? = nil) {
        self.item = item
        isNotEmpty = (item != nil)
        if !isNotEmpty {
            titleTextField.becomeFirstResponder()
        }
        titleTextField.text = item?.title
        contentTextView.text = item?.body
    }
}

// MARK: String+
private extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

// MARK: UITextView+
private extension UITextView {
    convenience init(
        font: UIFont,
        lineFragmentPadding: CGFloat,
        textContainerInset: UIEdgeInsets
    ) {
        self.init()
        
        self.font = font
        self.adjustsFontForContentSizeCategory = true
        self.textContainer.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset
        self.showsVerticalScrollIndicator = false
        self.keyboardDismissMode = .onDrag
        self.alwaysBounceVertical = true
    }
    
    var filteredText: String {
        return self.text ?? ""
    }
}

// MARK: UITextField+
private extension UITextField {
    
    convenience init(font: UIFont?, placeholder: String? = nil) {
        self.init()
        
        self.font = font
        self.placeholder = placeholder
        self.adjustsFontForContentSizeCategory = true
        self.returnKeyType = .done
    }
    
    var filteredText: String {
        return self.text ?? ""
    }
}
