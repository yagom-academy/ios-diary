//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kyungmin on 2023/08/30.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(diary: Diary) {
        self.diary = diary
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupConstraint()
        setupComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            addKeyboardObserver()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            removeKeyboardObserver()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        diaryTextView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.size.height, right: .zero)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
}

// MARK: Notification
extension DiaryDetailViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Setup Components
extension DiaryDetailViewController {
    private func setupComponents() {
        setupView()
        setupTextView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupTextView() {
        diaryTextView.text = String(format: NameSpace.diaryText, diary.title, diary.body)
        diaryTextView.keyboardDismissMode = .onDrag
    }
    
    private func setupNavigationBar() {
        navigationItem.title = diary.createdDate
    }
}

// MARK: Configure UI
extension DiaryDetailViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(diaryTextView)
    }
}

// MARK: Setup Constraint
extension DiaryDetailViewController {
    private func setupConstraint() {
        setupDiaryTextViewConstraint()
    }
    
    private func setupDiaryTextViewConstraint() {
        if #unavailable(iOS 15.0) {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
                diaryTextView.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
                diaryTextView.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
                diaryTextView.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
                diaryTextView.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor)
            ])
        }
    }
}

// MARK: Name Space
extension DiaryDetailViewController {
    private enum NameSpace {
        static let diaryText = "%@ \n\n %@"
    }
}
