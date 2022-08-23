//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    // MARK: - properties
    
    private let textView = DiaryDetailTextView()
    private lazy var keyboardManager = KeyboardManager(textView)
    
    // MARK: - life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextView()
        keyboardManager.addNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.removeNotificationObserver()
    }
    
    // MARK: - functions

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setupTextView() {
        if textView.text.isEmpty {
            textView.text = Design.textViewPlaceHolder
            textView.textColor = .lightGray
        }
        
        textView.delegate = self
        textView.setupConstraints(with: view)
        textView.layoutIfNeeded()
    }
}

// MARK: - extensions

extension DiaryDetailViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let diaryInformation = data as? Diary else { return }
        navigationItem.title = diaryInformation.createdAt.convert1970DateToString()
        
        textView.text = diaryInformation.title + Design.doubleLineBreak + diaryInformation.body
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Design.textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = Design.textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}

private enum Design {
    static let textViewPlaceHolder = "내용을 입력해주세요"
    static let doubleLineBreak = "\n\n"
}
