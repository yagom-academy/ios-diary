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
    private let diaryData = CoreDataManager()
    private var id: UUID?
    
    // MARK: - life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTextView()
        keyboardManager.addNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.removeNotificationObserver()
        updateDiary()
    }
    
    // MARK: - functions

    private func updateDiary() {
        let diaryInfomation = textView.text.split(separator: Design.textViewSeparator, maxSplits: 1)
        guard let id = id else { return }
        
        if diaryInfomation.isEmpty {
            diaryData.delete(id)
            return
        }
        
        let title = String(diaryInfomation[0])
        let body = getBody(title: title)
        
        let diary = Diary(uuid: id,
                          title: title,
                          body: body,
                          createdAt: Date().timeIntervalSince1970)
        
        diaryData.update(model: diary)
    }
    
    private func getBody(title: String) -> String {
        guard var text = textView.text else { return "" }
        
        for _ in 0..<title.count {
            text.removeFirst()
        }
        
        return text
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setupNavigationBar() {
        
        let buttonImage = UIImage(systemName: Design.moreButtonImageName)
        let rightBarButton = UIBarButtonItem(image: buttonImage,
                                             style: .done,
                                             target: self,
                                             action: #selector(didTapRightBarButton))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: Design.actionSheetShareActionTitle, style: .default) { _ in
            self.setupActivityView()
        }
        let deleteAction = UIAlertAction(title: Design.actionSheetDeleteActionTitle, style: .destructive) { _ in
            self.setupDeleteAlertAction()
        }
        let cancelAction = UIAlertAction(title: Design.actionSheetCancelActionTitle, style: .cancel)
                                                
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
                                                
        present(actionSheet, animated: true)
    }
    
    private func setupActivityView() {
        let title = textView.text.split(separator: Design.textViewSeparator, maxSplits: 1)
        
        let activityViews = title[0]
        let activityView = UIActivityViewController(activityItems: [activityViews],
                                                    applicationActivities: nil)

        present(activityView, animated: true)
    }
    
    private func setupDeleteAlertAction() {
        let cancelAlerController = UIAlertController(title: Design.cancelAlertControllerTitle,
                                                     message: Design.cancelAlertControllerMessage,
                                                     preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Design.cancelActionTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: Design.deleteActionTitle, style: .destructive) { _ in
            self.diaryData.delete(self.id ?? UUID())
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        cancelAlerController.addAction(cancelAction)
        cancelAlerController.addAction(deleteAction)
        
        present(cancelAlerController, animated: true)
    }
    
    private func setupTextView() {
        if textView.text == Design.emptyString {
            textView.text = Design.textViewPlaceHolder
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
        
        textView.delegate = self
        textView.setupConstraints(with: view)
        textView.layoutIfNeeded()
    }
    
    // MARK: - objc functions
    
    @objc private func didTapRightBarButton() {
        setupActionSheet()
    }
}

// MARK: - extensions

extension DiaryDetailViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let diaryInformation = data as? DiaryEntity,
              let title = diaryInformation.title,
              let body = diaryInformation.body else { return }
        
        navigationItem.title = diaryInformation.createdAt.convert1970DateToString()
        id = diaryInformation.uuid ?? UUID()
        textView.text = title + Design.lineBreak + body
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
    static let emptyString = ""
    static let textViewPlaceHolder = "내용을 입력해주세요"
    static let textViewSeparator: Character = "\n"
    static let lineBreak = "\n"
    static let moreButtonImageName = "ellipsis"
    static let actionSheetShareActionTitle = "Share..."
    static let actionSheetDeleteActionTitle = "Delete"
    static let actionSheetCancelActionTitle = "Cancel"
    static let cancelAlertControllerTitle = "진짜요?"
    static let cancelAlertControllerMessage = "정말로 삭제하시겠어요?"
    static let cancelActionTitle = "취소"
    static let deleteActionTitle = "삭제"
}
