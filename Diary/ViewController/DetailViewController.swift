//
//  DetailViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

fileprivate extension DiaryConstants {
    static let navigationBarRightButton = "ellipsis"
    static let actionSheetShareTitle = "Share..."
    static let actionSheetDeleteTitle = "Delete"
    static let actionSheetDeleteAlertTitle = "진짜요?"
    static let actionSheetDeleteAlertMessage = "정말로 삭제하시겠어요?"
    static let actionSheetDeleteAlertCancelTitle = "취소"
    static let actionSheetDeleteAlertDeleteTitle = "삭제"
    static let actionSheetCancleTitle = "Cancel"
}

final class DetailViewController: UIViewController {
    
    private lazy var detailView = DetailView(frame: view.frame)
    private let persistenceManager = DiaryEntityManager.shared
    private var diaryData: DiaryModel
    
    init(diaryData: DiaryModel) {
        self.diaryData = diaryData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Life Cycle Method

extension DetailViewController {
    
    override func loadView() {
        super.loadView()
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        detailView.setUpView(diaryData: diaryData)
        registerKeyboardNotifications()
        setNavigationBarRightButton()
        registerDidEnterBackgroundNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateListData()
    }
}

// MARK: - Method

extension DetailViewController {
    
    private func setNavigationBarTitle() {
        navigationItem.title = diaryData.createdAt.formattedDate
    }
    
    private func setNavigationBarRightButton() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: DiaryConstants.navigationBarRightButton),
            style: .plain,
            target: self,
            action: #selector(navigationBarRightButtonTapped)
        )
        navigationItem.rightBarButtonItem = button
    }
    
    private func updateListData() {
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        diaryData = DiaryModel(
            title: title,
            body: body,
            createdAt: diaryData.createdAt,
            id: diaryData.id
        )
        persistenceManager.update(diary: diaryData)
    }
    
    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: DiaryConstants.actionSheetDeleteAlertTitle,
            message: DiaryConstants.actionSheetDeleteAlertMessage,
            preferredStyle: .alert
        )
        let alertCancel = UIAlertAction(
            title: DiaryConstants.actionSheetDeleteAlertCancelTitle,
            style: .cancel
        )
        let alertDelete = UIAlertAction(
            title: DiaryConstants.actionSheetDeleteAlertDeleteTitle,
            style: .destructive
        ) { [weak self] _ in
            guard let diaryData = self?.diaryData else {
                return
            }
            self?.persistenceManager.delete(diary: diaryData)
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertDelete)
        alert.addAction(alertCancel)
        present(alert, animated: true)
    }
}

// MARK: - Action Method

extension DetailViewController {
    
    @objc private func navigationBarRightButtonTapped() {
        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let actionSheetShare = UIAlertAction(
            title: DiaryConstants.actionSheetShareTitle,
            style: .default
        ) { [weak self] _ in
            guard let diaryTitle = self?.detailView.titleField.text else {
                return
            }
            let activityViewController = UIActivityViewController(
                activityItems: [diaryTitle],
                applicationActivities: nil
            )
            self?.present(activityViewController, animated: true)
        }
        
        let actionSheetDelete = UIAlertAction(
            title: DiaryConstants.actionSheetDeleteTitle,
            style: .destructive
        ) { [weak self] _ in
            self?.showAlert()
        }
        
        let actionSheetCancel = UIAlertAction(
            title: DiaryConstants.actionSheetCancleTitle,
            style: .cancel
        )
        
        actionSheet.addAction(actionSheetCancel)
        actionSheet.addAction(actionSheetShare)
        actionSheet.addAction(actionSheetDelete)
        present(actionSheet, animated: true)
    }
    
    @objc private func didEnterBackground() {
        updateListData()
    }
}

// MARK: - Keyboard Method

extension DetailViewController {
    
    private func registerKeyboardNotifications() {
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }
        detailView.mainScrollView.contentInset.bottom = keyboardSize.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        detailView.mainScrollView.contentInset.bottom = .zero
        updateListData()
    }
}
