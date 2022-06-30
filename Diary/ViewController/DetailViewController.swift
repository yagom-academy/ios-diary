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

final class DetailViewController: UIViewController, Activitable, ErrorAlertProtocol {
    
    private lazy var detailView = DetailView(frame: view.frame)
    private let diaryData: DiaryModel
    private let diaryViewModel: DiaryViewModel
    
    init(diaryData: DiaryModel) {
        self.diaryData = diaryData
        self.diaryViewModel = DiaryViewModel(diaryModel: diaryData)
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
        setNavigationBarRightButton()
        registerDidEnterBackgroundNotification()
        registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        diaryViewModel.checkDiaryData(title: detailView.titleField.text, body: detailView.descriptionView.text)
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
            do {
                try self?.diaryViewModel.delete(diaryData: diaryData)
            } catch {
                self?.showAlert(alertMessage: ("\(CoreDataError.deleteError.errorDescription)"))
            }
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
            self?.activitySheet(activityItems: [diaryTitle])
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
        diaryViewModel.checkDiaryData(title: detailView.titleField.text, body: detailView.descriptionView.text)
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        diaryViewModel.checkDiaryData(title: detailView.titleField.text, body: detailView.descriptionView.text)
    }
}
