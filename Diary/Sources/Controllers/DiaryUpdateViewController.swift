//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/16.
//

import UIKit

final class DiaryUpdateViewController: UIViewController {
    
    // MARK: - Properties
    
    private var diaryItem: DiaryItem?
    
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
        
        setupKeyboardWillShowNoification()
        
        setupContentViewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardWillShowNoification()
        
        saveDiaryEntity()
    }
}

extension DiaryUpdateViewController {
    
    // MARK: - Methods
    
    func receiveData(_ diaryItem: DiaryItem?) {
        self.diaryItem = diaryItem
    }
}

private extension DiaryUpdateViewController {
    
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
        
        diaryItem?.title = data.title
        diaryItem?.body = data.body
    }
    
    func saveDiaryEntity() {
        convertTextToDiaryItem()
        
        guard let diaryItem = diaryItem else {
            return
        }
        
        DiaryCoreDataManager.shared.update(diaryItem: diaryItem)
    }
    
    // MARK: Configuring UI
    
    func configureRootViewUI() {
        self.view.backgroundColor = .systemBackground
        
        if let diaryItem = diaryItem {
            navigationItem.title = diaryItem.createdDate.localizedFormat()
        } else {
            navigationItem.title = Date().timeIntervalSince1970.localizedFormat()
        }
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
    
    func setupContentViewData() {
        let currentDiaryContent = createTextViewContent(diaryItem)
        displayDiaryDetailData(with: currentDiaryContent)
    }
    
    func displayDiaryDetailData(with textViewContent: String) {
        contentTextView.text = textViewContent
    }
    
    func createTextViewContent(_ diaryItem: DiaryItem?) -> String {
        guard let diaryItem = diaryItem else {
            return ""
        }
        
        return """
        \(diaryItem.title)
        
        \(diaryItem.body)
        """
    }
    
    // MARK: Setting Keyboard
    
    func setupKeyboardWillShowNoification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
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
}
