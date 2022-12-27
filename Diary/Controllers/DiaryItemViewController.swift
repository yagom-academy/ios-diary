//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by jin on 12/22/27.
//

import UIKit

class DiaryItemViewController: UIViewController {
    
    var diary: Diary?
    
    enum Constant {
        static let contentPlaceholder = "내용을 입력하세요."
        static let titlePlaceholder = "제목"
    }
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constant.titlePlaceholder
        textField.font = .preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextView()
        configureNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            manageCoreData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -10),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTextView() {
        self.contentTextView.delegate = self
        updateContentText(content: Constant.contentPlaceholder)
        self.contentTextView.textColor = .lightGray
    }
    
    func updateTitleText(title: String?) {
        self.titleTextField.text = title
    }
    
    func updateContentText(content: String?) {
        self.contentTextView.text = content
        self.contentTextView.textColor = .black
    }
}

// MARK: - Keyboard adjusting
extension DiaryItemViewController {
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.manageCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
            manageCoreData()
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        contentTextView.verticalScrollIndicatorInsets = contentTextView.contentInset

        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }
}

// MARK: - CoreData
extension DiaryItemViewController {
    
    @objc func manageCoreData() {
        if self.diary != nil {
            updateCoreData()
            return
        }
        
        createCoreData()
    }
    
    func createCoreData() {
        do {
            let title = titleTextField.text
            let content = contentTextView.text
            self.diary = try CoreDataManager.shared.createDiary(title: title, content: content, createdAt: Date().timeIntervalSince1970)
        } catch {
            print(error)
        }
    }
    
    func updateCoreData() {
        guard let diary else { return }
        diary.title = titleTextField.text
        diary.content = contentTextView.text
        
        do {
            try CoreDataManager.shared.updateDiary(updatedDiary: diary)
        } catch {
            print(error)
        }
    }
}

// MARK: - TextView Method
extension DiaryItemViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constant.contentPlaceholder {
            updateContentText(content: nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            updateContentText(content: Constant.contentPlaceholder)
            textView.textColor = .lightGray
        }
    }
}
