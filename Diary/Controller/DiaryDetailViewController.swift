//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/30.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var diaryManager: DiaryViewControllerUsecase?
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(diaryManger: DiaryViewControllerUsecase?) {
        self.diaryManager = diaryManger
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        guard let diary = diaryManager?.currentDiary else {
            return
        }
        
        diaryTextView.text = String(format: NameSpace.diaryText, arguments: [diary.title, diary.body])
        diaryTextView.keyboardDismissMode = .onDrag
    }
    
    private func setupNavigationBar() {
        navigationItem.title = diaryManager?.currentDiary?.createdDate
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

// MARK: Notification
extension DiaryDetailViewController {
    private func addBackgroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(upsertData),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
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
    
    private func removeBackgroundObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        diaryTextView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHide() {
        diaryTextView.contentInset = UIEdgeInsets.zero
        
        upsertData()
    }
}

// MARK: Upsert Data
extension DiaryDetailViewController {
    @objc private func upsertData() {
        guard let diary = diaryManager?.currentDiary else {
            return
        }

        diaryManager?.upsert(diary)
    }
}

// MARK: Name Space
extension DiaryDetailViewController {
    private enum NameSpace {
        static let diaryText = "%@\n%@"
    }
}
