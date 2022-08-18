//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/16.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var diaryItem: DiaryItem?
    
    // MARK: - UI Components

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardDismissMode = .interactive
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.text =
        """
        이곳에 제목을 작성해주세요

        이곳에 내용을 작성해주세요.
        """
        return textView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootViewUI()
        addUIComponents()
        configureLayout()
        
        setupKeyboardWillShowNoification()
        
        dispalyDiaryDetailData()
    }
    
    func recieveData(_ diaryItem: DiaryItem?) {
        self.diaryItem = diaryItem
    }
}

private extension DiaryDetailViewController {
    
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
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func dispalyDiaryDetailData() {
        guard let diaryItem = diaryItem else {
            return
        }
        
        let textViewContent = "\(diaryItem.title)\n\n\(diaryItem.body)"
        contentTextView.text = textViewContent
    }
    
    func setupKeyboardWillShowNoification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardFrame = keyboardFrame else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height + 50
        
        contentTextView.contentInset.bottom = keyboardHeight
    }
}
