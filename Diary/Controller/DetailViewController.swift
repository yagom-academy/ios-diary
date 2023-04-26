//
//  DetailViewController.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

final class DetailViewController: UIViewController {
    private var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    private var diaryItem: DiaryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone))
        configureTextView()
        configureInitailView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpNotification()
    }
    
    init(diaryItem: DiaryModel? = nil) {
        self.diaryItem = diaryItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func configureInitailView() {
        guard let item = diaryItem else {
            let today = Date().timeIntervalSince1970
            let todayText = Date.convertToDate(by: Int(today))
            
            self.navigationItem.title = todayText
            
            return
        }
        
        self.navigationItem.title = Date.convertToDate(by: item.date)
        self.textView.text = item.title + "\n\n" + item.body
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func showKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func hideKeyboard(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}

// MARK: UI
extension DetailViewController {
    private func configureTextView() {
        self.view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
