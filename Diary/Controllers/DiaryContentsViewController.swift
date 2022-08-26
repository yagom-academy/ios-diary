//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    
    // MARK: Properties
    
    private let diaryContentView = DiaryContentView()
    private var creationDate: Date?
    private var id: UUID?
    var diary: Diary?
    var isEditingMemo: Bool = false
    var isDeleted: Bool = false
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryContentView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItems()
        configureUI()
        configureNotificationCenter()
        configureCreationDate()
        configureID()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        renewCoreData()
    }
    
    // MARK: - Methods
    
    private func configureNavigationItems() {
        configureNavigationTitle()
        configureRightBarButtonItem()
    }
    
    private func configureNavigationTitle() {
        guard let diaryCreatedAt = diary?.createdAt else {
            title = Date().localizedString
            return
        }
        
        title = diaryCreatedAt.localizedString
    }
    
    private func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SystemImage.ellipsisCircle,
            style: .plain,
            target: self,
            action: #selector(sharedAndDeleteButtonTapped)
        )
    }
    
    @objc private func sharedAndDeleteButtonTapped() {
        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        let shareAction = UIAlertAction(
            title: ActionSheet.shareActionTitle,
            style: .default
        ) { [weak self] _ in
            self?.presentActivityView()
        }

        let deleteAction = UIAlertAction(
            title: ActionSheet.deleteActionTitle,
            style: .destructive
        ) { [weak self] _ in
            self?.presentDeleteAlert()
        }

        let cancelAction = UIAlertAction(
            title: ActionSheet.cancelActionTitle,
            style: .cancel
        )

        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true)
    }
    
    private func presentActivityView() {
        let activityViewController = UIActivityViewController(
            activityItems: [diaryContentView.textView.text as Any],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
    }
    
    private func presentDeleteAlert() {
        let alert = UIAlertController(
            title: Alert.deleteAlertTitle,
            message: Alert.deleteAlertMessage,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: Alert.cancelActionTitle,
            style: .cancel
        )
        
        let deleteAction = UIAlertAction(
            title: Alert.deleteActionTitle,
            style: .destructive
        ) { [weak self] _ in
            self?.isDeleted = true
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func configureUI() {
        guard let diaryTitle = diary?.title,
              let diaryBody = diary?.body else {
            return
        }
        
        let titleAttributedString = NSMutableAttributedString(
            string: diaryTitle,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)]
        )
        
        let lineBreakAttributedString = NSMutableAttributedString(string: String(NewLine.lineFeed))
        let bodyAttributedString = NSMutableAttributedString(
            string: diaryBody,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]
        )
        
        let diaryContentText = NSMutableAttributedString()
        diaryContentText.append(titleAttributedString)
        diaryContentText.append(lineBreakAttributedString)
        diaryContentText.append(bodyAttributedString)
        diaryContentView.textView.attributedText = diaryContentText
        diaryContentView.textView.contentOffset.y = .zero
    }
    
    private func configureNotificationCenter() {
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0
        )
        
        diaryContentView.textView.contentInset = contentInset
        diaryContentView.textView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        
        diaryContentView.textView.contentInset = contentInset
        diaryContentView.textView.scrollIndicatorInsets = contentInset
        
        renewCoreData()
    }
    
    private func renewCoreData() {
        guard let (title, body) = extractTitleAndBody(),
              let creationDate = creationDate,
              let id = id else {
            return
        }
        
        do {
            try determineDataProcessingWith(
                title,
                body,
                creationDate,
                id
            )
        } catch {
            presentErrorAlert(error)
        }
    }
    
    private func extractTitleAndBody() -> (String, String)? {
        guard let diaryConentViewText = diaryContentView.textView.text,
              diaryConentViewText.contains(NewLine.lineFeed) else {
            return (diaryContentView.textView.text, DiaryCoreData.emptyBody)
        }
        
        guard diaryContentView.textView.text.isEmpty == false,
            let lineBreakIndex = diaryConentViewText.firstIndex(of: NewLine.lineFeed)else {
            return nil
        }
        
        let firstLineBreakIndex = lineBreakIndex.utf16Offset(in: diaryConentViewText)
        
        let titleRange = NSMakeRange(.zero, firstLineBreakIndex)
        let title = (diaryConentViewText as NSString).substring(with: titleRange)
        
        let bodyRange = NSMakeRange(
            firstLineBreakIndex + 1,
            diaryConentViewText.count - title.count - 1
        )
        let body = (diaryConentViewText as NSString).substring(with: bodyRange)
        
        return (title, body)
    }
    
    private func determineDataProcessingWith(_ title: String, _ body: String, _ creationDate: Date, _ id: UUID) throws {
        let fetchSuccess = try? CoreDataManager.shared.fetchDiary(using: id)
        
        switch (fetchSuccess, isDeleted) {
        case (nil, false):
            try CoreDataManager.shared.saveDiary(
                title: title,
                body: body,
                createdAt: creationDate,
                id: id
            )
        case (_, false):
            try CoreDataManager.shared.update(
                title: title,
                body: body,
                id: id
            )
        case (_, true):
            try CoreDataManager.shared.delete(using: id)
        }
    }
    
    @objc func resignActive() {
        renewCoreData()
    }
    
    private func configureCreationDate() {
        guard let diary = diary else {
            creationDate = Date()
            return
        }
        creationDate = diary.createdAt
    }
    
    private func configureID() {
        guard let diary = diary else {
            id = UUID()
            return
        }
        id = diary.id
    }
    
    private func showKeyboard() {
        if isEditingMemo == false {
            diaryContentView.textView.becomeFirstResponder()
        }
    }
}
