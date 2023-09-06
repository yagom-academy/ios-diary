//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/02.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.keyboardDismissMode = .onDrag
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDelegates()
        setupKeyboardEvent()
    }
    
    private func configureDelegates() {
        diaryTextView.delegate = self
    }
}

extension DetailDiaryViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTextViewConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        navigationItem.title = DiaryDateFormatter.convertDate(Date(), Locale.current.identifier)
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func diaryTextViewConstraints() {
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}

extension DetailDiaryViewController {
    private func setupKeyboardEvent() {
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            
            return
        }
        
        diaryTextView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.height, right: .zero)
    }
    
    @objc private func keyboardWillHide() {
        diaryTextView.contentInset = UIEdgeInsets()
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
}
