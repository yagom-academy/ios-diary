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
        setupObject()
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

// MARK: Setup Object
extension DiaryDetailViewController {
    private func setupObject() {
        setupView()
        setupTextView()
        setupNavigationBar()
        setupUseCase()
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
        let selectDateButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(didTapOptionButton)
        )
        navigationItem.title = useCase?.diary.createdDate
        navigationItem.rightBarButtonItem = selectDateButton
    }
    
    private func setupUseCase() {
        useCase?.delegate = self
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

// MARK: DiaryDetailViewController Delegate
extension DiaryDetailViewController: DiaryDetailViewControllerUseCaseDelegate {
    func upsert(_ diary: Diary) {
        delegate?.diaryDetailViewController(self, upsert: diary)
    }
}

// MARK: TextView Delegate {
extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        upsertData()
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
        guard let diaryText = diaryTextView.text else {
            return
        }
        
        useCase?.updateDiary(diaryText)
    }
}

// MARK: Button Action
extension DiaryDetailViewController {
    @objc private func didTapOptionButton() {
        showOptionAlert()
    }
}

// MARK: Alert Action
extension DiaryDetailViewController {
    private func showOptionAlert() {
        let shareAction = UIAlertAction(title: NameSpace.shareEnglish, style: .default) { _ in
            self.showActivityView()
        }
        let deleteAction = UIAlertAction(title: NameSpace.deleteEnglish, style: .destructive) { _ in
            self.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: NameSpace.cancelEnglish, style: .cancel)
        let alert = UIAlertController.customAlert(
            alertTile: nil,
            alertMessage: nil,
            preferredStyle: .actionSheet,
            alertActions: [shareAction, deleteAction, cancelAction]
        )
        
        navigationController?.present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        let cancelAction = UIAlertAction(title: NameSpace.cancelKorean, style: .default)
        let deleteAction = UIAlertAction(title: NameSpace.deleteKorean, style: .destructive) { _ in
            guard let diary = self.useCase?.diary else {
                return
            }
            
            self.delegate?.diaryDetailViewController(self, delete: diary)
            self.navigationController?.popViewController(animated: true)
        }
        let alert = UIAlertController.customAlert(
            alertTile: NameSpace.deleteTitle,
            alertMessage: NameSpace.deleteSubtitle,
            preferredStyle: .alert,
            alertActions: [cancelAction, deleteAction]
        )
        
        navigationController?.present(alert, animated: true)
    }
    
    private func showErrorAlert(error: Error) {
        let alertAction = UIAlertAction(title: NameSpace.check, style: .default)
        let alert = UIAlertController.customAlert(
            alertTile: NameSpace.error,
            alertMessage: error.localizedDescription,
            preferredStyle: .alert,
            alertActions: [alertAction]
        )
        
        navigationController?.present(alert, animated: true)
    }
    
    private func showActivityView() {
        guard let text = useCase?.readDiary() else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, error in
            if let error {
                self.showErrorAlert(error: error)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: Name Space
extension DiaryDetailViewController {
    private enum NameSpace {
        static let check = "확인"
        static let error = "Error"
        static let deleteTitle = "진짜요?"
        static let deleteSubtitle = "정말로 삭제하시겠습니까?"
        static let cancelKorean = "취소"
        static let deleteKorean = "삭제"
        static let cancelEnglish = "Cancel"
        static let deleteEnglish = "Delete"
        static let shareEnglish = "Share..."
    }
}
