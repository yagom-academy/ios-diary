//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    private let coreDataManager = CoreDataManager.shared
    var diaryData: DiaryData?
    
    private let textTitle = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textView.isScrollEnabled = false
        textView.font = .boldSystemFont(ofSize: 15)
        textView.becomeFirstResponder()
        return textView
    }()
    
    private let textBody = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    private let textStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupData()
        setupStackView()
        setStackViewConstraints()
        setupKeyboardNotification()
        setupBackGroundNotification()
        setupNavigationBarButtonItem()
    }
    
    private func setupData() {
        textTitle.text = diaryData?.title
        textBody.text = diaryData?.body
        navigationItem.title = diaryData?.date
    }
    
    private func setupStackView() {
        textStackView.addArrangedSubview(textTitle)
        textStackView.addArrangedSubview(textBody)
        view.addSubview(textStackView)
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        textBody.contentInset.bottom = keyboardFrame.size.height
        textBody.scrollIndicatorInsets = textBody.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textBody.contentInset = UIEdgeInsets.zero
        textBody.scrollIndicatorInsets = textBody.contentInset
        
        coreDataManager.updateDiaryData(diary: diaryData, title: textTitle.text, body: textBody.text)
    }
    
    private func setupBackGroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataInBankground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func saveDataInBankground() {
        coreDataManager.updateDiaryData(diary: diaryData, title: textTitle.text, body: textBody.text)
    }
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) {_ in self.test_1() }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {_ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func test_1() {
        guard let title = self.textTitle.text else { return }
        let content = "Text"
        let items = [title, content]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

        // 컨트롤러를 닫은 후 실행할 완료 핸들러 지정
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
            // 성공했을 때 작업
           }  else  {
            // 실패했을 때 작업
           }
        }
      
        self.present(activityViewController, animated: true)
    }
}
