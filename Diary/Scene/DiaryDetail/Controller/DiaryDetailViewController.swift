//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import UIKit

final class DiaryDetailViewController: DataTaskViewController {
    // MARK: - Design

    private enum Design {
        static let alertControllerTitle = "진짜요?"
        static let alertControllerMessage = "정말로 삭제하시겠어요?🐒"
        static let alertCancelAction = "취소"
        static let alertDeleteAction = "삭제"
        static let alertShareAction = "공유"
    }
    
    // MARK: - properties
    
    private let diaryDetailView = DiaryDetailView()
    var diaryDetailData: DiaryModel?
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureViewLayout()
        configureDetailViewItem()
        configureKeyboardNotification()
        configureNavigationButton()
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData()
        removeRegisterForKeyboardNotification()
    }
    
    // MARK: - methods
    
    func saveData() {
        let inputText = diaryDetailView.seperateText()
        saveDiaryData(title: inputText.title,
                      body: inputText.body,
                      createdAt: diaryDetailData?.createdAt ?? Double(),
                      isExist: true)
    }
    
    @objc override func keyBoardShowAction(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        diaryDetailView.configureDetailTextViewInset(inset: keyboardHeight)
    }
    
    @objc override func keyboardDownAction() {
        view.endEditing(true)
        diaryDetailView.configureDetailTextViewInset(inset: 0)
    }
    
    private func configureNavigationButton() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .action,
                                             target: self,
                                             action: #selector(rightBarButtonDidTap))
        
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func shareAlertActionDidTap() {
        let title = diaryDetailData?.title
        let activityViewController = UIActivityViewController(activityItems: [title as Any],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func deleteAlertActionDidTap() {
        let alertController = UIAlertController(title: Design.alertControllerTitle,
                                                message: Design.alertControllerMessage,
                                                preferredStyle: .alert)
        let cancelAlertAction = UIAlertAction(title: Design.alertCancelAction,
                                              style: .cancel)
        let deleteAlertAction = UIAlertAction(title: Design.alertDeleteAction,
                                              style: .destructive) { _ in self.deleteDiaryData() }
        
        alertController.addAction(cancelAlertAction)
        alertController.addAction(deleteAlertAction)
        
        present(alertController, animated: true)
    }
    
    private func deleteDiaryData() {
        guard let createdAt = diaryDetailData?.createdAt else { return }
        
        CoreDataManager.shared.delete(createdAt: createdAt)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBarButtonDidTap() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let shareAlertAction = UIAlertAction(title: Design.alertShareAction,
                                             style: .default) { _ in self.shareAlertActionDidTap() }
        let deleteAlertAction = UIAlertAction(title: Design.alertDeleteAction,
                                              style: .destructive) { _ in self.deleteAlertActionDidTap() }
        let cancelAlertAction = UIAlertAction(title: Design.alertCancelAction,
                                              style: .cancel)
        
        alertController.addAction(shareAlertAction)
        alertController.addAction(deleteAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true)
    }
    
    private func configureView() {
        view.addSubview(diaryDetailView)
        navigationItem.title = diaryDetailData?.createdAt.convertDate()
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            diaryDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            diaryDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureDetailViewItem() {
        guard let title = diaryDetailData?.title,
              let body = diaryDetailData?.body else { return }
        
        diaryDetailView.configureDetailTextView(ofText: "\(title)\n\(body)")
    }
}
