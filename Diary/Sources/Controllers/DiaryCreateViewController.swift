//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/16.
//

import UIKit

final class DiaryCreateViewController: UIViewController {
    
    // MARK: - Properties
    
    private var newDiaryItem = DiaryItem(
        title: "",
        body: "",
        createdDate: Date().timeIntervalSince1970,
        uuid: UUID()
    )
    
    // MARK: - UI Components
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardDismissMode = .interactive
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
        addUIComponents()
        configureLayout()
        DiaryCoreDataManager.shared.saveDiary(diaryItem: newDiaryItem)
        setupKeyboardSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardWillShowNoification()
        
        updateNewDiaryEntity()
    }
}

private extension DiaryCreateViewController {
    
    // MARK: - Private Methods
    
    // MARK: - Configuring DiaryItem for Core Data
    
    func splitTitleAndBody(from text: String) -> (title: String, body: String) {
        guard let firstSpaceIndex = text.firstIndex(of: "\n") else {
            
            return (title: text, body: "")
        }
        
        let lastIndex = text.endIndex
        
        let titleSubstring = text[..<firstSpaceIndex]
        let bodySubstring = text[firstSpaceIndex..<lastIndex]
        
        let title = String(titleSubstring)
        let body = String(bodySubstring)
        
        return (title: title, body: body)
    }
    
    func convertTextToDiaryItem() {
        let data = splitTitleAndBody(from: contentTextView.text)
        
        newDiaryItem.title = data.title
        newDiaryItem.body = data.body
    }
    
    func updateNewDiaryEntity() {
        convertTextToDiaryItem()
        DiaryCoreDataManager.shared.update(diaryItem: newDiaryItem)
    }
    
    // MARK: Configuring UI
    
    func configureRootViewUI() {
        self.view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        navigationItem.title = newDiaryItem.createdDate.localizedFormat()
    }
    
    @objc func didEnterBackground(_ sender: Notification) {
        updateNewDiaryEntity()
    }
    
    func addUIComponents() {
        view.addSubview(contentTextView)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Configuring Model
    
    // MARK: Setting Keyboard
    
    func setupKeyboardSetup() {
        contentTextView.becomeFirstResponder()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardWillShowNoification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        guard let keyboardFrame = keyboardFrame else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.height + 50
        contentTextView.contentInset.bottom = keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        updateNewDiaryEntity()
    }
}
