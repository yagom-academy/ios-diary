//
//  DetailViewController.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import UIKit


final class DetailViewController: UIViewController {
    @IBOutlet weak private var detailTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var detailTextView: UITextView!
    private var coreDataManager: CoreDataManager = CoreDataManager()
    var diaryData: DiaryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addNotificationObserver()
        setAddButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObserver()
        setDiaryDataFromTextView()
        coreDataManager.update()
    }
    
    private func setAddButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(moreButtonAlert))
    }
    
    private func configureView() {
        guard let diaryData = diaryData else { return }
        navigationItem.title = diaryData.createdAt?.convertDate()
        detailTextView.delegate = self
        guard let title = diaryData.title,
              let body = diaryData.body else {
            detailTextView.text = "제목과 내용을 입력해주세요!"
            detailTextView.textColor = .gray
            return
        }
        detailTextView.text = "\(title)\n\n\(body)"
    }
    
    private func setDiaryDataFromTextView() {
        let result = detailTextView.text.separateTitleAndBody(titleWordsLimit: 20)
        diaryData?.body = result.body
        diaryData?.title = result.title
    }
}

// MARK: - Notification: handled keyboard Method

extension DetailViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sceneWillDeactivate),
                                               name: UIScene.willDeactivateNotification,
                                               object: nil)
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIScene.willDeactivateNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        handleScrollView(notification, isAppearing: true)
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        print("keyboardHide")
        handleScrollView(notification, isAppearing: false)
        setDiaryDataFromTextView()
        coreDataManager.update()
    }
    
    @objc
    private func sceneWillDeactivate() {
        setDiaryDataFromTextView()
        coreDataManager.update()
    }
    
    private func handleScrollView(_ notification: Notification, isAppearing: Bool) {
        guard let userinfo = notification.userInfo,
              let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        detailTextViewBottomConstraint.constant = isAppearing ? keyboardHeight : .zero
    }
}

// MARK: - extnesion: seperate detailTextView Title & Body

fileprivate extension String {
    func separateTitleAndBody(titleWordsLimit: Int) -> (title: String, body: String) {
        guard self != "제목과 내용을 입력해주세요!" else {
            return ("","")
        }
        var components = components(separatedBy: "\n\n")
        if components.count > 1 {
            let title = components.removeFirst()
            let body = components.filter { $0 != ""}.joined(separator: "\n\n")
            return (title, body)
        }
        if self.count < 20 {
            return (self, "")
        }
        let limitIndex = index(startIndex, offsetBy: titleWordsLimit)
        let title = self[startIndex..<limitIndex]
        let body = self[limitIndex..<endIndex]
        return (title.description, body.description)
    }
}



// MARK: - extension: Delete & Share Alert

extension DetailViewController {
    
    @objc
    private func moreButtonAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share..", style: .default) { action in
            self.presentActivityController()
        }
        let delteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(shareAction)
        alert.addAction(delteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func presentActivityController() {
        guard let title = diaryData?.title! else { return }
        let textToShare: String = title
        let activityController = UIActivityViewController(activityItems: [textToShare],
                                                          applicationActivities: nil)
        activityController.excludedActivityTypes = [.addToReadingList]
        self.present(activityController, animated: true)
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            guard let diaryData = self.diaryData else { return }
            self.coreDataManager.delete(data: diaryData)
            self.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "취소", style: .default)
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}

// MARK: - TextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailTextView.text == "제목과 내용을 입력해주세요!" {
            detailTextView.text = "\n\n"
            detailTextView.textColor = .black
        }
    }
}
