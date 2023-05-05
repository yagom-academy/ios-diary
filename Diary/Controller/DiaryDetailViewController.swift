//
//  DiaryDetailViewController.swift
//  Diary
//
// Created by SeHong on 2023/04/24.
//

import UIKit

final class DiaryDetailViewController: UIViewController {

    private enum ButtonConstant {
        static let shareActionTitle = "공유"
        static let cancelActionTitle = "취소"
        static let deleteActionTitle = "삭제"
        static let deleteAlertTitle = "진짜요?"
        static let deleteAlertMessage = "정말로 삭제 하시겠어요?"
    }

    private let coreDataManager = CoreDataManager.shared
    
    private var diaryData: Diary?
    
    private var isDeleted: Bool = false
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(diaryData: Diary? = nil) {
        self.diaryData = diaryData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupLayout()
        setData()
        setFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard !isDeleted else { return }
        
        saveOrUpdateDiary()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain,
                        target: self, action: #selector(tappedDetailButton))
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print(#function)
        saveOrUpdateDiary()
    }
    
    @objc
    private func tappedDetailButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: ButtonConstant.shareActionTitle, style: .default) { [weak self] _ in
            guard let self else { return }
            self.tappedSharebutton()
        }
        
        let deleteAction = UIAlertAction(title: ButtonConstant.deleteActionTitle, style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.createDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: ButtonConstant.cancelActionTitle, style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach(actionSheet.addAction(_:))
        
        present(actionSheet, animated: true)
    }
    
    func saveOrUpdateDiary() {
        let titleText = titleTextView.text
        let bodyText = bodyTextView.text
        
        guard titleText != "" || bodyText != "" else { return }
        
        if let diaryData {
            diaryData.title = titleText
            diaryData.body = bodyText
            coreDataManager.updateDiaryData(newDiaryData: diaryData)
        } else {
            coreDataManager.saveDiaryData(titleText: titleText, bodyText: bodyText) { [weak self] diary in
                guard let self else { return }
                self.diaryData = diary
            }
        }
    }
    
    private func tappedSharebutton() {
        shareText(diaryData?.title)
    }
    
    private func deleteDiary() {
        guard let diaryData = diaryData else { return }
        coreDataManager.deleteDiaryData(data: diaryData)
        self.diaryData = nil
        isDeleted = true
    }
    
    func createDeleteAlert() {
        let alert = UIAlertController(
            title: ButtonConstant.deleteAlertTitle,
            message: ButtonConstant.deleteAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: ButtonConstant.cancelActionTitle,
            style: .default,
            handler: nil
        )
        let deleteAction = UIAlertAction(
            title: ButtonConstant.deleteActionTitle,
            style: .destructive) { [weak self] _ in
                guard let self else { return }
                self.deleteDiary()
                self.navigationController?.popViewController(animated: true)
            }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextView)
        view.addSubview(bodyTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }
    
    private func setData() {
        diaryData.map {
            title = DateToStringFormatter.changeToString(from: $0.createdAt)
            titleTextView.text = $0.title
            bodyTextView.text = $0.body
        }
    }
    
    private func setFirstResponder() {
        if diaryData == nil {
            titleTextView.becomeFirstResponder()
        }
    }
}
