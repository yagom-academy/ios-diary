//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    // MARK: - properties
    
    private let textView = DiaryDetailTextView()
    private lazy var keyboardManager = KeyboardManager(textView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        setupTextView()
        textView.setupConstraints(with: view)
        textView.layoutIfNeeded()
        keyboardManager.addNotificationObserver()
    }
    
    func setupTextView() {
        if textView.text == "" {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
    }
    
    // MARK: - objc functions
    
    
}

// MARK: - extensions

extension DiaryDetailViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let diaryInformation = data as? JSONModel else { return }
        navigationItem.title = diaryInformation.createdAt.convertToString()
        
        textView.text = diaryInformation.title + "\n\n" + diaryInformation.body
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력해주세요" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        }
    }
}

extension DiaryDetailViewController {
    
}
