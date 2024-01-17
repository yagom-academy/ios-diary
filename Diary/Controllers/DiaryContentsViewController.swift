//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    //MARK: - Property
    private let coreDataManager = CoreDataManager.shared
    var diaryData: DiaryData?
    
    private let contentTextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textView.isScrollEnabled = true
        textView.font = .boldSystemFont(ofSize: 15)
        textView.becomeFirstResponder()
        return textView
    }()

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupContentView()
        setContentViewConstraints()
        setupKeyboardNotification()
        setupBackGroundNotification()
        setupNavigationBarButtonItem()
    }
    
    //MARK: - Helper
    private func setupData() {
        contentTextView.text = diaryData?.title
//        textBody.text = diaryData?.body
        navigationItem.title = diaryData?.date
    }
    
    private func setupContentView() {
        view.addSubview(contentTextView)
    }
    
    private func setContentViewConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        contentTextView.contentInset.bottom = keyboardFrame.size.height
        contentTextView.scrollIndicatorInsets = contentTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        contentTextView.contentInset = UIEdgeInsets.zero
        contentTextView.scrollIndicatorInsets = contentTextView.contentInset
        
        coreDataManager.updateDiaryData(diary: diaryData, title: contentTextView.text, body: contentTextView.text)
    }
    
    private func setupBackGroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataInBankground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func saveDataInBankground() {
        coreDataManager.updateDiaryData(diary: diaryData, title: contentTextView.text, body: contentTextView.text)
    }
    
    private func setupNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) {_ in self.showActivityView() }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {_ in self.showDeleteAlert()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func showActivityView() {
        guard let title = self.contentTextView.text else { return }

        let activityViewController = UIActivityViewController(activityItems: [title], applicationActivities: nil)
      
        self.present(activityViewController, animated: true)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [self] _ in
            guard let diaryData = self.diaryData else { return }
            coreDataManager.deleteDiaryData(diary: diaryData)
            
            navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
}
