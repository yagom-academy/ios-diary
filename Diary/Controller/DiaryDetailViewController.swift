//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/30.
//

import UIKit

protocol DiaryDetailViewControllerDelegate: AnyObject {
    func diaryDetailViewController(_ diaryDetailViewController: DiaryDetailViewController, upsert diary: Diary)
    func diaryDetailViewController(_ diaryDetailViewController: DiaryDetailViewController, delete diary: Diary)
    func diaryDetailViewController(dismiss diaryDetailViewController: DiaryDetailViewController)
}

final class DiaryDetailViewController: UIViewController {
    private var useCase: DiaryDetailViewControllerUseCase?
    private weak var delegate: DiaryDetailViewControllerDelegate?
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(useCase: DiaryDetailViewControllerUseCase, delegate: DiaryDetailViewControllerDelegate) {
        self.useCase = useCase
        self.delegate = delegate
        
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
        diaryTextView.text = useCase?.readDiary()
        diaryTextView.keyboardDismissMode = .onDrag
        diaryTextView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.title = useCase?.diary.createdDate
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
    }
}

// MARK: Upsert Data
extension DiaryDetailViewController {
    @objc private func upsertData() {
        guard let diary = useCase?.diary else {
            return
        }
        
        delegate?.diaryDetailViewController(self, upsert: diary)
    }
}

// MARK: TextView Delegate {
extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let diaryText = textView.text else {
            return
        }
        
        useCase?.updateDiary(diaryText)
        upsertData()
    }
}
