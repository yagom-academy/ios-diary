//
//  DiaryViewController.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/25.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    private var sampleDiary: [SampleDiary] = []
    
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        guard let sample = sampleDiary.first else { return UITextView() }
        textView.text = sample.title + "\n" + sample.body
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .secondaryLabel
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        diaryTextView.delegate = self
        
        configureNavigationBar()
        configureDiaryTextView()
        setUpNotification()
        hideKeyBoard()
    }
    
    private func configureNavigationBar() {
        let now = Date().timeIntervalSince1970
        let today = Int(now)
        
        self.navigationItem.title = DateFormatterManager.convertToFomattedDate(of: today)
    }
    
    private func configureDiaryTextView() {
        view.addSubview(diaryTextView)
        let safeArea = view.safeAreaLayoutGuide
        
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 14),
            diaryTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -14),
            diaryTextView.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor)
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = diaryTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    private func hideKeyBoard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fillSampleDiary(_ dairy: [SampleDiary] ) {
        sampleDiary = dairy
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.textColor = .black
    }
}
