//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/27.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var diary: SampleDiary?
    private var isAutomaticKeyboard: Bool?
    
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        guard let diary = self.diary else { return textView }
        textView.text = diary.title + "\n\n" + diary.body
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
        
        return textView
    }()
    
    init(diary: SampleDiary?, isAutomaticKeyboard: Bool?) {
        self.diary = diary
        self.isAutomaticKeyboard = isAutomaticKeyboard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureDiaryTextView()
        setUpNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAutomaticKeyboard == true {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    private func configureNavigationBar() {
        let now = Date().timeIntervalSince1970
        let today = now
        
        self.navigationItem.title = DateFormatterManager.shared.convertToFomattedDate(of: today)
    }
    
    private func configureDiaryTextView() {
        view.addSubview(diaryTextView)
        let safeArea = view.safeAreaLayoutGuide
        
        diaryTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let heightConstraint = diaryTextView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        heightConstraint.priority = .defaultHigh
        
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            diaryTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 14),
            diaryTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -14),
            diaryTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            heightConstraint
        ])
    }
    
    private func setUpNotification() {
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = diaryTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
